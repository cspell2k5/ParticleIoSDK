//
//  File.swift
//  
//
//  Created by Craig Spell on 11/16/23.
//

import Foundation



public typealias FilePath = String


///Created to use extentions giving the ability to remove hard coded strings in your app.
///
///Intended Usage Example
///
///````swift
///
///            extension GroupName {
///                 public static let myGroupName = GroupName("my_group_name")
///            }
///
///````
///

public struct VariableName {
    public let rawValue: String
    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }
}

///Encapsulation of a productIdOrSlug.
///Failable init only fails if nil is passed as the rawvalue.
public struct ProductID {
    
    public let rawValue: String
    
    public init(_ rawValue: String) {
//        if rawValue == nil { return nil }
        self.rawValue = rawValue
    }
    
    public init?(_ rawValue: Int?) {
        if rawValue == nil { return nil }
        self.rawValue = String(rawValue!)
    }
}

///The name of a particle group.
public struct GroupName: Hashable {
    
    ///The string value of the instance..
    public var rawValue: String
    
    ///Creates a new instance.
    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }
}

///The name of a particle event.
public struct EventName {
    
    ///The string value of the instance..
    public let rawValue: String
    
    ///Creates a new instance.
    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }
}

///Encapsulation of an organization name..
public struct OrganizationName: Decodable {
    
    ///The raw value of the intance.
    public let rawValue: String
    
    ///Creates a new OrganizationName.
    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }
}

///Encapsulation of the ICCID number of the device.
public struct ICCIDNumber: Hashable {
    
    ///The raw value of the intance.
    public let rawValue: String
    
    ///Creates a new ICCIDNumber.
    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }
}

///Encapsulation of the serial number of the device.
public struct SerialNumber: Hashable {
    
    ///The raw value of the intance.
    public let rawValue: String
    
    ///Creates a new SerialNumber.
    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }
}

///Encapsulation of the device IEMI Number.
public struct IEMINumber: Hashable {
    
    ///The raw value of the intance.
    public let rawValue: String
    
    ///Creates a new IEMINumber
    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }
}

///Encapsulation of the device id.
public struct DeviceID: Hashable {
    
    ///The raw value of the intance.
    public let rawValue: String
    
    ///Creates a new DeviceID.
    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }
    
    ///Creates a new DeviceID.
    ///This initializer fails only if nil is passed as the argument.
    internal init?(_ rawValue: Int?) {
        if rawValue == nil { return nil }
        self.rawValue = String(rawValue!)
    }
}

///Encapsulation of the device name.
public struct DeviceName: Hashable {
    
    ///The raw value of the intance.
    public let rawValue: String
    
    ///Creates a new DeviceName.
    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }
}

///Encapsulation of the device function names.
public struct FunctionName: Hashable {
    
    ///The raw value of the intance.
    public let rawValue: String
    
    ///Creates a new FunctionName.
    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }
}

///Encapsulation of the device function arguments name.
public struct FunctionArgument: Hashable {
    
    ///The raw value of the intance.
    public let rawValue: String
    
    ///Creates a new FunctionArgument.
    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }
}
