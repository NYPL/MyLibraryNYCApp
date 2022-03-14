// Load Active Admin's styles into Webpacker,
// see `active_admin.scss` for customization.
import "../stylesheets/active_admin";
import "../stylesheets/active_admin_custom";

import "@activeadmin/activeadmin";
import "activeadmin_addons"
import active_admin_custom from './active_admin_custom'
window.activateSchool = active_admin_custom.activateSchool
window.makeAvailableTeacherSet = active_admin_custom.makeAvailableTeacherSet
