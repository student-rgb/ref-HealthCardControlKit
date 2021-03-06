//
//  Copyright (c) 2020 gematik GmbH
//  
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//  
//     http://www.apache.org/licenses/LICENSE-2.0
//  
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import CardReaderProviderApi
import Foundation
import HealthCardAccessKit
@testable import HealthCardControlKit
import Nimble
import XCTest

final class SelectCommandIntegrationTest: HCCTerminalTestCase {

    func testSelectRoot() {

        expect {
            var mTemp: HealthCardResponseType?
            HealthCardCommand.Select.selectRoot()
                    .execute(on: HCCTerminalTestCase.healthCard)
                    .run(on: Executor.trampoline)
                    .on { event in
                        mTemp = event.value
                    }
            return mTemp?.responseStatus
        } == ResponseStatus.success
    }

    func testSelectFileByAidThenSelectParentFolder() {

        expect {
            var mTemp: HealthCardResponseType?
            HealthCardCommand.Select.selectFile(with: EgkFileSystem.DF.GDD.aid)
                    .execute(on: HCCTerminalTestCase.healthCard)
                    .flatMap { _ in
                        HealthCardCommand.Select.selectRoot()
                                .execute(on: HCCTerminalTestCase.healthCard)
                    }
                    .run(on: Executor.trampoline)
                    .on { event in
                        mTemp = event.value
                    }
            return mTemp?.responseStatus
        } == ResponseStatus.success
    }

    func testReadFileBySfiWithLowerThanSpecifiedLength() {
        let cEgkAutCVCE256Count = 0x00DE

        expect {
            var mTemp: HealthCardResponseType?
            try HealthCardCommand.Read.readFileCommand(with: EgkFileSystem.EF.cEgkAutCVCE256.sfid!,
                                                       // swiftlint:disable:previous force_unwrapping
                                                       ne: cEgkAutCVCE256Count + 1,
                                                       offset: 0)
                    .execute(on: HCCTerminalTestCase.healthCard, readTimeout: 30)
                    .run(on: Executor.trampoline)
                    .on { event in
                        mTemp = event.value
                    }
            return mTemp?.responseStatus
        } == ResponseStatus.endOfFileWarning
    }

    static let allTests = [
        ("testSelectRoot", testSelectRoot),
        ("testSelectFileByAidThenSelectParentFolder", testSelectFileByAidThenSelectParentFolder),
        ("testReadFileBySfiWithLowerThanSpecifiedLength", testReadFileBySfiWithLowerThanSpecifiedLength)
    ]
}
