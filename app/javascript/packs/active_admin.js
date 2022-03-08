// Load Active Admin's styles into Webpacker,
// see `active_admin.scss` for customization.
import "../stylesheets/active_admin";
import "@activeadmin/activeadmin";
import "activeadmin_addons"


function activateSchool(schoolId, activate) {
  if (activate == true){
    $('#activate-school-' + schoolId + '-container').hide();
    $('#inactivate-school-' + schoolId + '-container').show();
  } else {
    $('#inactivate-school-' + schoolId + '-container').hide();
    $('#activate-school-' + schoolId + '-container').show();
  }
};

function makeAvailableTeacherSet(teacherSetId, make_available) {
  if (make_available == true){
    $('#make-available-teacher-set-' + teacherSetId + '-container').hide();
    $('#make-unavailable-teacher-set-' + teacherSetId + '-container').show();
  } else {
    $('#make-unavailable-teacher-set-' + teacherSetId + '-container').hide();
    $('#make-available-teacher-set-' + teacherSetId + '-container').show();
  }
};