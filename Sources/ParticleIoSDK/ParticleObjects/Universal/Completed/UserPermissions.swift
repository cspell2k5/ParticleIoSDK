    //
    //  UserScopes.swift
    //  ParticleSDK
    //
    //  Created by Craig Spell on 9/13/23.
    //

import Foundation


/// UserScope Options Recognizable by the particle server
///
/// - Option Values
///   * clients:create
///   * clients:list
///   * clients:remove
///   * clients:update
///   * configuration:get
///   * configuration:update
///   * customers:list
///   * customers:remove
///   * customers:update
///   * devices.diagnostics.metadata:get
///   * devices.diagnostics.summary:get
///   * devices.diagnostics:get
///   * devices.diagnostics:update
///   * devices.function:call
///   * devices.variable:get
///   * devices:get
///   * devices:import
///   * devices:list
///   * devices:ping
///   * devices:release
///   * devices:remove
///   * devices:update
///   * events:get
///   * events:send
///   * firmware.binary:get
///   * firmware:create
///   * firmware:get
///   * firmware:list
///   * firmware:release
///   * firmware:remove
///   * firmware:update
///   * groups:impact:get
///   * groups:create
///   * groups:get
///   * groups:list
///   * groups:remove
///   * groups:update
///   * integrations:create
///   * integrations:get
///   * integrations:list
///   * integrations:remove
///   * integrations:test
///   * integrations:update
///   * locations:get
///   * organization:get
///   * products:get
///   * products:list
///   * service.agreements.notifications:list
///   * service.agreements.usage.reports:create
///   * service.agreements.usage.reports:get
///   * service.agreements:list
///   * sims:status:get
///   * sims:usage:get
///   * sims:get
///   * sims:import
///   * sims:list
///   * sims:remove
///   * sims:update
///   * teams.users:invite
///   * teams.users:list
///   * teams.users:remove
///   * teams.users:update
///   * customer=username
//final public class UserScopes: Codable {
//    
//    private init(rawValue: String) {
//        self.rawValue = rawValue
//    }
//
//    public let rawValue: String
//    
//    public static let clients_create = UserScopes(rawValue: "clients:create")
//    public static let clients_list = UserScopes(rawValue: "clients:list")
//    public static let clients_remove = UserScopes(rawValue: "clients:remove")
//    public static let clients_update = UserScopes(rawValue:"clients:update")
//    public static let configuration_get = UserScopes(rawValue:"configuration:get")
//    public static let configuration_update = UserScopes(rawValue:"configuration:update")
//    public static let customers_list = UserScopes(rawValue:"customers:list")
//    public static let customers_remove = UserScopes(rawValue:"customers:remove")
//    public static let customers_update = UserScopes(rawValue:"customers:update")
//    public static let devices_diagnostics_metadata_get = UserScopes(rawValue:"devices.diagnostics.metadata:get")
//    public static let devices_diagnostics_summary_get = UserScopes(rawValue:"devices.diagnostics.summary:get")
//    public static let devices_diagnostics_get = UserScopes(rawValue:"devices.diagnostics:get")
//    public static let devices_diagnostics_update = UserScopes(rawValue:"devices.diagnostics:update")
//    public static let devices_function_call = UserScopes(rawValue:"devices.function:call")
//    public static let devices_variable_get = UserScopes(rawValue:"devices.variable:get")
//    public static let devices_get = UserScopes(rawValue:"devices:get")
//    public static let devices_import = UserScopes(rawValue:"devices:import")
//    public static let devices_list = UserScopes(rawValue:"devices:list")
//    public static let devices_ping = UserScopes(rawValue:"devices:ping")
//    public static let devices_release = UserScopes(rawValue:"devices:release")
//    public static let devices_remove = UserScopes(rawValue:"devices:remove")
//    public static let devices_update = UserScopes(rawValue:"devices:update")
//    public static let events_get = UserScopes(rawValue:"events:get")
//    public static let events_send = UserScopes(rawValue:"events:send")
//    public static let firmware_binary_get = UserScopes(rawValue:"firmware.binary:get")
//    public static let firmware_create = UserScopes(rawValue:"firmware:create")
//    public static let firmware_get = UserScopes(rawValue:"firmware:get")
//    public static let firmware_list = UserScopes(rawValue:"firmware:list")
//    public static let firmware_release = UserScopes(rawValue:"firmware:release")
//    public static let firmware_remove = UserScopes(rawValue:"firmware:remove")
//    public static let firmware_update = UserScopes(rawValue:"firmware:update")
//    public static let groups_impact_get = UserScopes(rawValue:"groups.impact:get")
//    public static let groups_create = UserScopes(rawValue:"groups:create")
//    public static let groups_get = UserScopes(rawValue:"groups:get")
//    public static let groups_list = UserScopes(rawValue:"groups:list")
//    public static let groups_remove = UserScopes(rawValue:"groups:remove")
//    public static let groups_update = UserScopes(rawValue:"groups:update")
//    public static let integrations_create = UserScopes(rawValue:"integrations:create")
//    public static let integrations_get = UserScopes(rawValue:"integrations:get")
//    public static let integrations_list = UserScopes(rawValue:"integrations:list")
//    public static let integrations_remove = UserScopes(rawValue:"integrations:remove")
//    public static let integrations_test = UserScopes(rawValue:"integrations:test")
//    public static let integrations_update = UserScopes(rawValue:"integrations:update")
//    public static let locations_get = UserScopes(rawValue:"locations:get")
//    public static let organization_get = UserScopes(rawValue:"organization:get")
//    public static let products_get = UserScopes(rawValue:"products:get")
//    public static let products_list = UserScopes(rawValue:"products:list")
//    public static let service_agreements_notifications_list = UserScopes(rawValue:"service_agreements.notifications:list")
//    public static let service_agreements_usage_reports_create = UserScopes(rawValue:"service_agreements.usage_reports:create")
//    public static let service_agreements_usage_reports_get = UserScopes(rawValue:"service_agreements.usage_reports:get")
//    public static let service_agreements_list = UserScopes(rawValue:"service_agreements:list")
//    public static let sims_status_get = UserScopes(rawValue:"sims.status:get")
//    public static let sims_usage_get = UserScopes(rawValue:"sims.usage:get")
//    public static let sims_get = UserScopes(rawValue:"sims:get")
//    public static let sims_import = UserScopes(rawValue:"sims:import")
//    public static let sims_list = UserScopes(rawValue:"sims:list")
//    public static let sims_remove = UserScopes(rawValue:"sims:remove")
//    public static let sims_update = UserScopes(rawValue:"sims:update")
//    public static let teams_users_invite = UserScopes(rawValue:"teams.users:invite")
//    public static let teams_users_list = UserScopes(rawValue:"teams.users:list")
//    public static let teams_users_remove = UserScopes(rawValue:"teams.users:remove")
//    public static let teams_users_update = UserScopes(rawValue:"teams.users:update")
//    
//}


public enum UserPermissions: String, CaseIterable {
    
    case clients_create =  "clients:create"
    case clients_list =  "clients:list"
    case clients_remove =  "clients:remove"
    case clients_update = "clients:update"
    case configuration_get = "configuration:get"
    case configuration_update = "configuration:update"
    case customers_list = "customers:list"
    case customers_remove = "customers:remove"
    case customers_update = "customers:update"
    case devices_diagnostics_metadata_get = "devices.diagnostics.metadata:get"
    case devices_diagnostics_summary_get = "devices.diagnostics.summary:get"
    case devices_diagnostics_get = "devices.diagnostics:get"
    case devices_diagnostics_update = "devices.diagnostics:update"
    case devices_function_call = "devices.function:call"
    case devices_variable_get = "devices.variable:get"
    case devices_get = "devices:get"
    case devices_import = "devices:import"
    case devices_list = "devices:list"
    case devices_ping = "devices:ping"
    case devices_release = "devices:release"
    case devices_remove = "devices:remove"
    case devices_update = "devices:update"
    case events_get = "events:get"
    case events_send = "events:send"
    case firmware_binary_get = "firmware.binary:get"
    case firmware_create = "firmware:create"
    case firmware_get = "firmware:get"
    case firmware_list = "firmware:list"
    case firmware_release = "firmware:release"
    case firmware_remove = "firmware:remove"
    case firmware_update = "firmware:update"
    case groups_impact_get = "groups.impact:get"
    case groups_create = "groups:create"
    case groups_get = "groups:get"
    case groups_list = "groups:list"
    case groups_remove = "groups:remove"
    case groups_update = "groups:update"
    case integrations_create = "integrations:create"
    case integrations_get = "integrations:get"
    case integrations_list = "integrations:list"
    case integrations_remove = "integrations:remove"
    case integrations_test = "integrations:test"
    case integrations_update = "integrations:update"
    case locations_get = "locations:get"
    case organization_get = "organization:get"
    case products_get = "products:get"
    case products_list = "products:list"
    case service_agreements_notifications_list = "service_agreements.notifications:list"
    case service_agreements_usage_reports_create = "service_agreements.usage_reports:create"
    case service_agreements_usage_reports_get = "service_agreements.usage_reports:get"
    case service_agreements_list = "service_agreements:list"
    case sims_status_get = "sims.status:get"
    case sims_usage_get = "sims.usage:get"
    case sims_get = "sims:get"
    case sims_import = "sims:import"
    case sims_list = "sims:list"
    case sims_remove = "sims:remove"
    case sims_update = "sims:update"
    case teams_users_invite = "teams.users:invite"
    case teams_users_list = "teams.users:list"
    case teams_users_remove = "teams.users:remove"
    case teams_users_update = "teams.users:update"
}
