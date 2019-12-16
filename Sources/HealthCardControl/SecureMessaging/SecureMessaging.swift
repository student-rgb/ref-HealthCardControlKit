//
//  Copyright (c) 2019 gematik GmbH
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

/// Component that attached to a `SecureCardChannel` takes care of message de-/encryption.
public protocol SecureMessaging {

    /// Encrypt the APDU Command.
    /// - Parameter:
    ///     - command: The APDU command to encrypt
    /// - Returns: The APDU command encrypted accordingly to the SecureMessaging protocol.
    func encrypt(command: CommandType) throws -> CommandType

    /// Decrypt the APDU Response.
    /// - Parameter:
    ///     - response: The APDU response to decrypt
    /// - Returns: The APDU response decrypted accordingly to the SecureMessaging protocol.
    func decrypt(response: ResponseType) throws -> ResponseType

    /// Destruct the information held by this object.
    func invalidate()
}
