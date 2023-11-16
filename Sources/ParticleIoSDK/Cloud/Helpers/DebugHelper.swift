//
//  DebugHelper.swift
//  ParticleSDK
//
//  Created by Craig Spell on 9/28/23.
//

import Foundation

    //MARK: - Debug Properties
extension CloudResource {
    
    var debugDescription: String {
        
        switch self {
                
            case .getVariableValue(let name,_,let deviceID,_):
                return "getvariable:\nParticleVariable \nname:\(name)\ndevice:\(String(describing: deviceID))\n"
                
            case .generateAccessToken(client: let client, credentials: let credentials, grantType: let grantType, expiresIn: let expiresIn, expireAt: let expireAt):
                return "generateAccessToken \ncllient:\(String(describing: client))\ncredentials:\(credentials)\ngrantType:\(grantType)\nexpiresIn:\(String(describing: expiresIn))\nexpiresAt:\(String(describing: expireAt))\n"
                
            case .listAccessTokens(credentials: let credentials, otp: let otp):
                return "listAccessTokens:\ncredentials:\(credentials)\notp:\(String(describing: otp))\n"
                
            case .deleteAnAccessToken(tokenID: let tokenID, credentials: let credentials):
                return "deleteAnAccessToken:\ntokenID:\(tokenID)\ncredentials:\(credentials)\n"
                
            case .deleteAllAccessTokens(token: let token):
                return "deleteAllAccessTokens:\ntoken:\(token.debugDescription)\n"
                
            case .deleteCurrentAccessToken(token: let token):
                return "deleteCurrentAccessToken:\ntoken:\(token.debugDescription)\n"
                
            case .getCurrentAccessTokenInfo(token: let token):
                return "verifyToken:\ntoken:\(token.debugDescription)\n"
                
            case .listClients(productIdorSlug: let productIdorSlug, token: let token):
                return "listClients:\nproductIdorSlug:\(String(describing: productIdorSlug))\ntoken:\(token.debugDescription)\n"
                
            case .createClient(let appName, let productIdorSlug, let redirect, let type, let token):
                return "createClient:\nappName:\(appName)\nproductIdorSlug:\(String(describing: productIdorSlug))\nredirect: \(String(describing: redirect))\n type:\(type)\ntoken:\(token.debugDescription)\n"
                
            case .updateClient(client: let client, newName: let newName, newScope: let newScope, productIdorSlug: let productIdorSlug, token: let token):
                return "updateClient:\nclient:\(client)\nnewName:\(String(describing: newName))\nnewScope:\(String(describing: newScope?.rawValue))\nproductIdorSlug:\(String(describing: productIdorSlug))\ntoken:\(token.debugDescription)\n"
                
            case .deleteClient(client: let client, productIdorSlug: let productIdorSlug, token: let token):
                return "deleteClient:\nclient:\(client)\nproductIdorSlug:\(String(describing: productIdorSlug))\ntoken:\(token.debugDescription)\n"
                
            case .createAPiUser(let type, let parameters, let token):
                return "createAPiUser:\ntype:\(type)\nparameters:\(parameters.debugDescription)\ntoken:\(token.debugDescription)\n"
                
            case .updateAPiUser(let type, let parameters, let token):
                return "updateAPiUser:\ntype:\(type)\nparameters:\(parameters.debugDescription)\ntoken:\(token.debugDescription)\n"
                
            case .listAPiUsers(let type, let token):
                return "updateAPiUser:\ntype:\(type)\ntoken:\(token.debugDescription)\n"
                
            case .deleteAPiUser(type: let type, username: let username, token: let token):
                return "deleteAPiUser:\ntype:\(type)\nusername:\(username)\ntoken:\(token.debugDescription)\n"
                
            case .listDevices(arguments: let arguments, token: let token):
                return "listDevices:\narguments:\(arguments.debugDescription)\ntoken:\(token.debugDescription)\n"
            
            case .listProductDevices(productIdOrSlug: let productIdOrSlug, arguments: let arguments, token: let token):
                return "listProductDevices\nproductIdOrSlug: \(productIdOrSlug.rawValue)\narguments: \(String(describing: arguments?.debugDescription))\ntoken: \(token.debugDescription)\n"
            
            case .importDevices(let devices, let productID, let arguments, let token):
                return "importDevices\ndevices: \(devices)\nproductID: \(productID)\narguments: \(arguments.debugDescription)\ntoken: \(token.debugDescription)\n"
           
            case .getDeviceEventStream(eventName: let eventName, deviceID: let deviceID, token: let token):
                return "getDeviceEventStream\neventName: \(String(describing: eventName.rawValue))\ndeviceID: \(deviceID.rawValue)\ntoken: \(token.debugDescription)\n"
           
            case .getProductEventStream(eventName: let eventName, productIdOrSlug: let productIdOrSlug, token: let token):
                return "getProductEventStream\neventName: \(String(describing: eventName?.rawValue))\nproductIdOrSlug: \(productIdOrSlug.rawValue)\ntoken: \(token.debugDescription)\n"

            case .getDeviceInfo(deviceID: let deviceID, token: let token):
                return "getDeviceInfo:\ndeviceID:\(deviceID.rawValue)\ntoken:\(token.debugDescription)\n"

            case .getProductDeviceInfo(let deviceID, let productIdorSlug, let token):
                return "getProductDeviceInfo:\ndeviceID:\(String(describing: deviceID))\nproductIdorSlug:\(productIdorSlug)\ntoken:\(token.debugDescription)\n"

            case .callFunction(let deviceID, arguments: let arguments, token: let token):
                return "callFunction:\ndeviceID:\(deviceID)\narguments:\(arguments.description)\ntoken:\(token.debugDescription)\n"
                
            case .pingDevice(deviceID: let deviceID, productIdorSlug: let productIdorSlug, token: let token):
                return "pingDevice:\ndeviceID:\(deviceID)\nproductIdorSlug:\(String(describing: productIdorSlug))\ntoken:\(token.debugDescription)\n"
                
            case .renameDevice(deviceID: let deviceID, productIdorSlug: let productIdorSlug, newName: let newName, token: let token):
                return "renameDevice:\ndeviceID:\(deviceID)\nproductIdorSlug:\(String(describing: productIdorSlug))\nnewName:\(newName)\ntoken:\(token.debugDescription)\n"
                
            case .addDeviceNotes(deviceID: let deviceID, productIdorSlug: let productIdorSlug, note: let note, token: let token):
                return "addDeviceNotes:deviceID:\(deviceID)\nproductIdorSlug:\(String(describing: productIdorSlug))\nnote:\(note)\ntoken:\(token.debugDescription)\n"
                
            case .createClaimCode(arguments: let arguments, token: let token):
                return "createClaimCode:\narguments:\(arguments.debugDescription)\ntoken:\(token.debugDescription)\n"
                
            case .claimDevice(deviceID: let deviceID, let isTransfer, token: let token):
                return "claimDevice:deviceID:\(deviceID)\nisTransfer: \(isTransfer)\ntoken:\(token.debugDescription)\n"
                
//            case .requestDeviceTransferFromAnotherUser(deviceID: let deviceID, token: let token):
//                return "requestDeviceTransferFromAnotherUser:deviceID:\(deviceID)\nrequestTransfer:required-`true`\ntoken:\(token.debugDescription)\n"
                
            case .removeDeviceFromProduct(deviceID: let deviceID, productIdorSlug: let productIdorSlug, token: let token):
                return "removeDeviceFromProduct:deviceID:\(deviceID)\nproductIdorSlug:\(productIdorSlug)\ntoken:\(token.debugDescription)\n"
                
            case .unclaimDevice(deviceID: let deviceID, productIdorSlug: let productIdorSlug, token: let token):
                return "unclaimDevice:\ndeviceID:\(deviceID)\nproductIdorSlug:\(String(describing: productIdorSlug))\ntoken:\(token.debugDescription)\n"
                
            case .signalDevice(deviceID: let deviceID, rainbowState: let rainbowState, token: let token):
                return "signalDevice:deviceID:\(deviceID)\nrainbowState:\(rainbowState)\ntoken:\(token.debugDescription)\n"
                
            case .forceOverTheAirUpdates(deviceID: let deviceID, let forceEnabled, token: let token):
                return "forceEnable_OTA_Updates:deviceID:\(deviceID)\nenabled:\(forceEnabled)\ntoken:\(token.debugDescription)\n"
                
            case .lookUpDeviceInformation(serialNumber: let serialNumber, token: let token):
                return "lookUpDeviceIdentificationFromSerialNumber:\nserialNumber:\(serialNumber)\ntoken:\(token.debugDescription)\n"
                
            case .refreshDeviceVitals(deviceID: let deviceID, productIDorSlug: let productIDorSlug, token: let token):
                return "refreshDeviceVitals:\ndeviceID:\(deviceID)\nproductIDorSlug:\(String(describing: productIDorSlug))\ntoken:\(token.debugDescription)\n"
                
            case .getLastKnownDeviceVitals(deviceID: let deviceID, productIDorSlug: let productIDorSlug, token: let token):
                return "getLastKnownDeviceVitals:\ndeviceID:\(deviceID)\nproductIDorSlug:\(String(describing: productIDorSlug))token:\(token.debugDescription)\n"
                
            case .getAllHistoricalDeviceVitals(deviceID: let deviceID, productIDorSlug: let productIDorSlug, startDate: let startDate, endDate: let endDate, token: let token):
                return "getAllHistoricalDeviceVitals:\ndeviceID:\(deviceID)\nproductIDorSlug:\(String(describing: productIDorSlug))\nstartDate:\(String(describing: startDate))\nendDate:\(String(describing: endDate))\ntoken:\(token.debugDescription)\n"
                
            case .getDeviceVitalsMetadata(deviceID: let deviceID, productIDorSlug: let productIDorSlug, token: let token):
                return "getDeviceVitalsMetadata:deviceID:\(deviceID)\nproductIDorSlug:\(String(describing: productIDorSlug))\ntoken:\(token.debugDescription)\n"
                
            case .getCellularNetworkStatus(let deviceID, iccid: let iccid, productIDorSlug: let productIDorSlug, token: let token):
                return "getCellularNetworkStatus:\ndeviceID\(deviceID)\niccid:\(iccid)\nproductIDorSlug:\(String(describing: productIDorSlug))\ntoken:\(token.debugDescription)\n"
                
            case .getUser(token: let token):
                return "getUser:\ntoken:\(token.debugDescription)\n"
                
            case .updateUser(username: let username, password: let password, accountInfo: let accountInfo, currentPassword: let currentPassword, token: let token):
                return "updateUser:\nusername:\(username)\npassword:\(String(describing: password))\naccountInfo:\(accountInfo)\ncurrentPassword:\(currentPassword)\ntoken:\(token.debugDescription)\n"
                
            case .deleteUser(password: let password, token: let token):
                return "deleteUser:\npassword:\(password)\ntoken:\(token.debugDescription)\n"
                
            case .forgotPassword(username: let username):
                return "forgotPassword:username:\(username)\n"
                
            case .approveQuarantinedDevice(deviceID: let deviceID, productIDorSlug: let productIDorSlug, token: let token):
                return "approveQuarantinedDevice:\ndeviceID:\(deviceID)\nproductIDorSlug:\(productIDorSlug)\ntoken:\(token.debugDescription)\n"
                
            case .denyQuarantinedDevice(deviceID: let deviceID, productIDorSlug: let productIDorSlug, token: let token):
                return "denyQuarantinedDevice:\ndeviceID:\(deviceID)\nproductIDorSlug:\(productIDorSlug)\ntoken:\(token.debugDescription)\n"
                
            case .listSimCards(arguments: let arguments, token: let token):
                return "listSimCards:\narguments:\(arguments.debugDescription)token:\(token.debugDescription)\n"
                
            case .getSimInformation(iccid: let iccid, productIDorSlug: let productIDorSlug, token: let token):
                return "getSimInformation:\niccid:\(iccid)\nproductIDorSlug:\(productIDorSlug)\ntoken:\(token.debugDescription)\n"
                
            case .getDataUsage(iccid: let iccid, productIDorSlug: let productIDorSlug, token: let token):
                return "getDataUsage:iccid:\(iccid)\nproductIDorSlug:\(String(describing: productIDorSlug))\ntoken:\(token.debugDescription)\n"
                
            case .getDataUsageForProductFleet(productIDorSlug: let productIDorSlug, token: let token):
                return "getDataUsageForProductFleet:\nproductIDorSlug:\(productIDorSlug)\ntoken:\(token.debugDescription)\n"
                
            case .activateSIM(iccid: let iccid, token: let token):
                return "activateSIM:\niccid:\(iccid)\ntoken:\(token.debugDescription)\n"
                
            case .importAndActivateProductSIMs(productIDorSlug: let productIDorSlug, sims: let sims, file: let file, token: let token):
                return "importAndActivateProductSIMs:\nproductIDorSlug:\(productIDorSlug)\nsims:\(String(describing: sims))\nfile:\(String(describing: file?.description))\ntoken:\(token.debugDescription)\n"
                
            case .deactivateSIM(iccid: let iccid, productIDorSlug: let productIDorSlug, token: let token):
                return "deactivateSIM:iccid:\(iccid)\nproductIDorSlug:\(String(describing: productIDorSlug))\ntoken:\(token.debugDescription)\n"
                
            case .reactivateSIM(iccid: let iccid, productIDorSlug: let productIDorSlug, token: let token):
                return "reactivateSIM:\niccid:\(iccid)\nproductIDorSlug:\(String(describing: productIDorSlug))\ntoken:\(token.debugDescription)\n"
                
            case .releaseSimFromAccount(iccid: let iccid, productIDorSlug: let productIDorSlug, token: let token):
                return "releaseSimFromAccount:\niccid:\(iccid)\nproductIDorSlug:\(String(describing: productIDorSlug))\ntoken:\(token.debugDescription)\n"
                
            case .getEventStream(eventName: let eventName, token: let token):
                return "getStreamOfEventsForDevice:\neventName:\(String(describing: eventName.rawValue))\ntoken:\(token.debugDescription)\n"

            case .publishEvent(eventName: let eventName, productIDorSlug: let productIDorSlug, data: let data, private: let isPrivate, ttl: let ttl, token: let token):
                return "publishEvent:\neventName:\(eventName)\nproductIDorSlug:\(String(describing: productIDorSlug))\ncontent:\(String(describing: data))\nprivate:\(String(describing: isPrivate))\nttl:\(String(describing: ttl))\ntoken:\(token.debugDescription)\n"
                
            case .createWebhook(arguments: let arguments, token: let token):
                return "createWebhook:\narguments:\(arguments.debugDescription)\ntoken:\(token.debugDescription)\n"

            case .listProducts(token: let token):
                return "listProducts:\ntoken:\(token.debugDescription)\n"
                
            case .retrieveProduct(productIDorSlug: let productIDorSlug, token: let token):
                return "retrieveProduct:\nproductIDorSlug:\(productIDorSlug)\ntoken:\(token.debugDescription)\n"
                
            case .listTeamMembers(productIDorSlug: let productIDorSlug, token: let token):
                return "listTeamMembers:\nproductIDorSlug:\(productIDorSlug)\ntoken:\(token.debugDescription)\n"
                
            case .inviteTeamMember(productIDorSlug: let productIDorSlug, username: let username, role: let role, token: let token):
                return "inviteTeamMember:\nproductIDorSlug:\(productIDorSlug)\nusername:\(username)\nrole:\(role)\ntoken:\(token.debugDescription)\n"
                
            case .createAnAPIuser(productIdOrSlug: let productIdOrSlug, friendlyName: let friendlyName, scope: let scope, token: let token):
                return "createAnAPIuser:\nproductIdOrSlug:\(productIdOrSlug)\nfriendlyName:\(friendlyName)\nscope:\(scope)\ntoken:\(token.debugDescription)\n"
                
            case .updateTeamMember(productIDorSlug: let productIDorSlug, username: let username, token: let token):
                return "updateTeamMember:\nproductIDorSlug:\(productIDorSlug)\nusername:\(username)\ntoken:\(token.debugDescription)\n"
                
            case .removeTeamMember(productIDorSlug: let productIDorSlug, username: let username, token: let token):
                return "removeTeamMember:\nproductIDorSlug:\(productIDorSlug)\nusername:\(username)\ntoken:\(token.debugDescription)\n"

            case .queryLocationForDevicesWithinProduct(let arguments, let token):
                return "queryLocationForDevicesWithinProduct:\nnproductIDorSlug:\(arguments.productIDorSlug.rawValue)\narguments:\(arguments.debugDescription)\ntoken:\(token.debugDescription)\n"

            case .createCustomerWithToken(let productIDorSlug, let credentials, let token):
                return "createCustomerWithToken:\nproductIDorSlug:\(productIDorSlug)\nusername:\(credentials.id)\npassword:\(credentials.secret.suffix(4))\ntoken:\(token.debugDescription)\n"
                
            case .createCustomerWithClient(productIDorSlug: let productIDorSlug, client: let client, username: let username, password: let password):
                return "createCustomerWithClient:\nproductIDorSlug:\(productIDorSlug)\nclient:\(client)\nusername:\(username)\npassword:\(String(describing: password))\n"
                
            case .createCustomerImplicit(productIDorSlug: let productIDorSlug, client: let client, let credentials):
                return "createCustomerImplicit:\nproductIDorSlug:\(productIDorSlug)\nclient:\(client)\nusername:\(credentials.username)\npassword:\(credentials.password)\n"
                
            case .listCustomersForProduct(productIdOrSlug: let productIdOrSlug, token: let token):
                return "listCustomersForProduct:\nproductIdOrSlug:\(productIdOrSlug)\ntoken:\(token.debugDescription)\n"
                
            case .generateCustomerWithScopedAccessToken(arguments: let arguments):
                return "generateCustomerWithScopedAccessToken:\narguments:\(arguments.debugDescription)\n"
            case .updateCustomerPassword(productIDorSlug: let productIDorSlug, let credentials, token: let token):
                return "updateCustomerPassword:\nproductIDorSlug:\(productIDorSlug)\nusername:\(credentials.username)\npassword:\(credentials.password)\ntoken:\(token.debugDescription)\n"
                
            case .deleteA_Customer(productIDorSlug: let productIDorSlug, username: let username, token: let token):
                return "deleteA_Customer:\nproductIDorSlug:\(productIDorSlug)\nusername:\(username)\ntoken:\(token.debugDescription)\n"
                
            case .resetPassword(productIDorSlug: let productIDorSlug, let email, token: let token):
                return "resetPassword:\nproductIDorSlug:\(productIDorSlug)\ncustomerEmail:\(email)\n\ntoken:\(token.debugDescription)\n"

            case .updateDeviceFirmware(deviceID: let deviceID, version: let version, token: let token):
                return "updateDeviceFirmware:\ndeviceID: \(deviceID.rawValue)\nversion: \(version)\ntoken: \(token.debugDescription)\n"
            
            case .flashDeviceWithSourceCode(deviceID: let deviceID, sourceCodePaths: let sourceCodePaths, let version, token: let token):
                return "flashDeviceWithSourceCode\ndeviceID: \(deviceID.rawValue)\nsourceCodePaths: [\(sourceCodePaths.joined(separator: "\n"))]\nversion: \(version)\ntoken: \(token.debugDescription)\n"
                
            case .flashDeviceWithPreCompiledBinary(deviceID: let deviceID, build_target_version: let build_target_version, file: let file, token: let token):
                return "flashDeviceWithPreCompiledBinary\ndeviceID: \(deviceID.rawValue)\nbuild_target_version: \(build_target_version)\nfile: \(file)\ntoken: \(token.debugDescription)\n"
                
            case .compileSourceCode(filePaths: let filePaths, platform_id: let platform_id, product_id: let product_id, build_target_version: let build_target_version, token: let token):
                return "compileSourceCode\nfilePaths: \(filePaths.joined(separator: ",\n"))\nplatform_id: \(platform_id)aka platform:\(platform_id.description)\nproduct_id: \(product_id.rawValue)\nbuild_target_version: \(build_target_version)\ntoken: \(token.debugDescription)\n"
                
            case .listFirmwareBuildTargets(featured: let featured):
                return "listFirmwareBuildTargets\nfeatured: \(featured)"
                
            case .lockProductDevice(deviceID: let deviceID, productIdOrSlug: let productIdOrSlug, desired_firmware_version: let desired_firmware_version, flash: let flash, token: let token):
                return "lockProductDevice\ndeviceID: \(deviceID.rawValue)\nproductIdOrSlug: \(productIdOrSlug.rawValue)\ndesired_firmware_version: \(desired_firmware_version)\nflash: \(flash)\ntoken: \(token.debugDescription)\n"
                
            case .unlockProductDevice(deviceID: let deviceID, productIdOrSlug: let productIdOrSlug, token: let token):
                return "unlockProductDevice\ndeviceID: \(deviceID.rawValue)\nproductIdOrSlug: \(productIdOrSlug.rawValue)\ntoken: \(token.debugDescription)\n"
                
            case .markProductDevelopmentDevice(deviceID: let deviceID, productIdOrSlug: let productIdOrSlug, development: let development, token: let token):
                return "markProductDevelopmentDevice\ndeviceID: \(deviceID.rawValue)\nproductIdOrSlug: \(productIdOrSlug.rawValue)\ndevelopment: \(development)\ntoken: \(token.debugDescription)\n"
                
            case .unmarkProductDevelopmentDevice(deviceID: let deviceID, productIdOrSlug: let productIdOrSlug, development: let development, token: let token):
                return "unmarkProductDevelopmentDevice\ndeviceID: \(deviceID.rawValue)\nproductIdOrSlug: \(productIdOrSlug.rawValue)\ndevelopment: \(development)\ntoken: \(token.debugDescription)\n"
                
            case .getProductFirmware(productIdOrSlug: let productIdOrSlug, version: let version, token: let token):
                return "getProductFirmware\nproductIdOrSlug: \(productIdOrSlug)\nversion: \(version)\ntoken: \(token.debugDescription)\n"
                
            case .listAllProductFirmwares(productIdOrSlug: let productIdOrSlug, token: let token):
                return "listAllProductFirmwares\nproductIdOrSlug: \(productIdOrSlug.rawValue)\ntoken: \(token.debugDescription)\n"
                
        case .uploadProductFirmware(let productID, let path, arguments: let arguments, token: let token):
                return "uploadProductFirmware\nproductID: \(productID)\npath: \(path)\narguments: \(arguments.debugDescription)\ntoken: \(token.debugDescription)\n"
                
            case .editProductFirmware(let productID, arguments: let arguments, token: let token):
                return "editProductFirmware\nproductID: \(productID)\narguments: \(arguments.debugDescription)\ntoken: \(token.debugDescription)\n"
                
            case .downloadFirmwareBinary(productIdOrSlug: let productIdOrSlug, version: let version, token: let token):
                return "downloadFirmwareBinary\nproductIdOrSlug: \(productIdOrSlug.rawValue)\nversion: \(version)\ntoken: \(token.debugDescription)\n"
                
            case .releaseProductFirmware(let productID, arguments: let arguments, token: let token):
                return "releaseProductFirmware\nproductID: \(productID)\narguments: \(arguments.debugDescription)\ntoken: \(token.debugDescription)\n"
                
            case .deleteUnreleasedFirmwareBinary(productIdOrSlug: let productIdOrSlug, version: let version, token: let token):
                return "deleteUnreleasedFirmwareBinary\nproductIdOrSlug: \(productIdOrSlug.rawValue)\nversion: \(version)\ntoken: \(token.debugDescription)\n"
                
            case .listLibraries(arguments: let arguments, token: let token):
                return "listLibraries\narguments: \(arguments.description)\ntoken: \(token.debugDescription)\n"
                
            case .getLibraryDetails(arguments: let arguments, token: let token):
                return "getLibraryDetails\narguments: \(arguments)\ntoken: \(token.debugDescription)\n"

            case .getLibraryVersions(libraryName: let libraryName, version: let version, token: let token):
                return "getLibraryVersions\nlibraryName: \(libraryName)\nversion: \(version)\ntoken: \(token.debugDescription)\n"
                
            case .uploadLibraryVersion(libraryName: let libraryName, filePath: let filePath, token: let token):
                return "uploadLibraryVersion\nlibraryName: \(libraryName)\nfilePath: \(filePath)\ntoken: \(token.debugDescription)\n"
                
            case .makeLibraryVersionPublic(libraryName: let libraryName, visibility: let visibility, token: let token):
                return "makeLibraryVersionPublic\nlibraryName: \(libraryName)\nvisibility: \(visibility)\ntoken: \(token.debugDescription)\n"
                
            case .getDeviceGroup(productIdOrSlug: let productIdOrSlug, groupName: let groupName, token: let token):
                return "getDeviceGroup\nproductIdOrSlug: \(productIdOrSlug.rawValue)\ngroupName: \(groupName.rawValue)\ntoken: \(token.debugDescription)\n"
                
            case .listDeviceGroups(productIdOrSlug: let productIdOrSlug, name: let name, token: let token):
                return "listDeviceGroups\nproductIdOrSlug: \(productIdOrSlug.rawValue)\nname: \(String(describing: name))\ntoken: \(token.debugDescription)\n"
                
            case .createDeviceGroup(productIdOrSlug: let productIdOrSlug, name: let name, color: let color, description: let description, token: let token):
                return "createDeviceGroup\nproductIdOrSlug: \(productIdOrSlug.rawValue)\nname: \(name)\ncolor:\(String(describing: color))\ndescription: \(String(describing: description))\ntoken: \(token.debugDescription)\n"
                
            case .editDeviceGroup(productIdOrSlug: let productIdOrSlug, groupName: let groupName, newName: let newName, color: let color, description: let description, token: let token):
                return "editDeviceGroup\nproductIdOrSlug: \(productIdOrSlug.rawValue)\ngroupName: \(groupName.rawValue)\nnewName: \(String(describing: newName))\ncolor: \(String(describing: color))\ndescription: \(String(describing: description))\ntoken: \(token.debugDescription)\n"
                
            case .deleteDeviceGroup(productIdOrSlug: let productIdOrSlug, groupName: let groupName, token: let token):
                return "deleteDeviceGroup\nproductIdOrSlug: \(productIdOrSlug.rawValue)\ngroupName: \(groupName.rawValue)\ntoken: \(token.debugDescription)\n"
                
            case .assignGroupsToDevice(deviceId: let deviceId, productIdOrSlug: let productIdOrSlug, groups: let groups, token: let token):
                return "assignGroupsToDevice\ndeviceId: \(deviceId.rawValue)\nproductIdOrSlug: \(productIdOrSlug.rawValue)\ngroups: \(groups.debugDescription)\ntoken: \(token.debugDescription)\n"
                
            case .batchAssignGroupsToDevices(productIdOrSlug: let productIdOrSlug, token: let token):
                return "batchAssignGroupsToDevices\nproductIdOrSlug: \(productIdOrSlug.rawValue)\ntoken: \(token.debugDescription)\n"
                
            case .impactOfTakingAction(productIdOrSlug: let productIdOrSlug, arguments: let arguments, token: let token):
                return "impactOfTakingAction\nproductIdOrSlug: \(productIdOrSlug.rawValue)\narguments: \(arguments.debugDescription)\ntoken: \(token.debugDescription)\n"
                
            case .queryLocationForOneDeviceWithinProduct(productIDorSlug: let productIDorSlug, deviceID: let deviceID, dateRange: let dateRange, rect_bl: let rect_bl, rect_tr: let rect_tr, token: let token):
                return "queryLocationForOneDeviceWithinProduct\nproductIDorSlug: \(productIDorSlug.rawValue)\ndeviceID: \(deviceID.rawValue)\ndateRange: \(String(describing: dateRange?.debugDescription))\nrect_bl: \(String(describing: rect_bl))\nrect_tr: \(String(describing: rect_tr))\ntoken: \(token.debugDescription)\n"
                
            case .getProductConfiguration(productIDorSlug: let productIDorSlug, token: let token):
                return "getProductConfiguration\nproductIDorSlug: \(productIDorSlug.rawValue)\ntoken: \(token.debugDescription)\n"
                
            case .getDeviceConfiguration(deviceID: let deviceID, productIDorSlug: let productIDorSlug, token: let token):
                return "getDeviceConfiguration\ndeviceID: \(deviceID.rawValue)\nproductIDorSlug: \(productIDorSlug.rawValue)\ntoken: \(token.debugDescription)\n"
            
            case .getSchema(productIdOrSlug: let productIdOrSlug, deviceID: let deviceID, token: let token):
                return "getSchema\nproductIdOrSlug:\(productIdOrSlug.rawValue)\ndeviceID: \(String(describing: deviceID?.rawValue))\ntoken: \(token.debugDescription)\n"
           
            case .deleteOrResetConfigurationSchema(productIdOrSlug: let productIdOrSlug, deviceID: let deviceID, resetToProductDefaults: let resetToProductDefaults, token: let token):
                return "deleteOrResetConfigurationSchema\nproductIdOrSlug: \(productIdOrSlug.rawValue)\ndeviceID: \(String(describing: deviceID?.rawValue))\nresetToProductDefaults: \(resetToProductDefaults)\ntoken: \(token.debugDescription)\n"
            
            case .setConfiguration(productIdOrSlug: let productIdOrSlug, deviceID: let deviceID, token: let token):
                return "setConfiguration\nproductIdOrSlug: \(productIdOrSlug.rawValue)\ndeviceID: \(String(describing: deviceID?.rawValue))\ntoken: \(token.debugDescription)\n"
            
            case .setConfigurationSchema(productIdOrSlug: let productIdOrSlug, deviceID: let deviceID, token: let token):
                return "setConfigurationSchema\nproductIdOrSlug: \(productIdOrSlug.rawValue)\ndeviceID: \(String(describing: deviceID?.rawValue))\ntoken: \(token.debugDescription)\n"
            
            case .getServiceAgreements(token: let token):
                return "getServiceAgreements\ntoken: \(token.debugDescription)\n"
            
            case .getUserServiceAgreements(orgName: let orgName, token: let token):
                return "getUserServiceAgreements\norgName: \(orgName.debugDescription)\ntoken: \(token.debugDescription)\n"
            
            case .getOrganizationServiceAgreements(productIDorSlug: let productIDorSlug, token: let token):
                return "getOrganizationServiceAgreements\nproductIDorSlug: \(productIDorSlug.rawValue)\ntoken: \(token.debugDescription)\n"
            
            case .getUserUsageReport(usageReportId: let usageReportId, token: let token):
                return "getUserUsageReport\nusageReportId:\(usageReportId)\ntoken: \(token.debugDescription)\n"
            
            case .getOrgUsageReport(usageReportId: let usageReportId, orgSlugOrId: let orgSlugOrId, token: let token):
                return "getOrgUsageReport\nusageReportId: \(usageReportId)\norgSlugOrId: \(orgSlugOrId)\ntoken: \(token.debugDescription)\n"
            
            case .createUserUsageReport(arguments: let arguments, token: let token):
                return "createUserUsageReport\narguments\(arguments.debugDescription)\ntoken: \(token.debugDescription)\n"
           
            case .createOrgUsageReport(arguments: let arguments, token: let token):
                return "createOrgUsageReport\narguments: \(arguments.debugDescription)\ntoken: \(token.debugDescription)\n"
           
            case .getUserNotificationsForCurrentUsagePeriod(serviceAgreementId: let serviceAgreementId, token: let token):
                return "getUserNotificationsForCurrentUsagePeriod\nserviceAgreementId: \(serviceAgreementId)\ntoken: \(token.debugDescription)\n"
           
            case .getOrganizationNotificationsForCurrentUsagePeriod(orgSlugOrId: let orgSlugOrId, serviceAgreementId: let serviceAgreementId, token: let token):
                return "getOrganizationNotificationsForCurrentUsagePeriod\norgSlugOrId: \(orgSlugOrId)\nserviceAgreementId: \(serviceAgreementId)\ntoken: \(token.debugDescription)\n"
      
            default: return String(describing: self)
//            case .enableAzureIoTHubintegration:
//                <#code#>
//            case .enableGoogleCloudPlatformIntegration:
//                <#code#>
//            case .enableGoogleMapsintegration:
//                <#code#>
//            case .editWebhook:
//                <#code#>
//            case .editAzureIoTHubIntegration:
//                <#code#>
//            case .editGoogleCloudPlatformIntegration:
//                <#code#>
//            case .editGoogleMapsIntegration:
//                <#code#>
//            case .getIntegration:
//                <#code#>
//            case .listIntegrations:
//                <#code#>
//            case .testAnIntegration:
//                <#code#>
//            case .deleteAnIntegration:
//                <#code#>
//            case .trackerLocationEvents:
//                <#code#>
//            case .enhancedLocationEvents:
//                <#code#>
//            case .locationPointSchema:
//                <#code#>
        }
    }
}
