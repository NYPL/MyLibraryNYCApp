/*
 * An OOP-ified version of:
 * https://help.exacttarget.com/en-US/documentation/exacttarget/content/conversion_tracking/#section_16
 * Author: brianfoo@nypl.org
 * Example usage:
 *    _et.track("My Receipt Page", "<data amt=\"1\" unit=\"Downloads\" accumulate=\"true\" />");
 */

var ExactTarget = (function () {

  var ExpireDays = 90;

  // get cookie
  function getCookie(cookiename) {
    var startC, endC;
    if(document.cookie.length >0) {
      startC = document.cookie.indexOf(cookiename+"=");
      if (startC != -1) {
        startC += cookiename.length+1;
        endC = document.cookie.indexOf(";",startC);
        if(endC ==-1) endC = document.cookie.length;
        return unescape(document.cookie.substring(startC,  endC));
      }
    }
    return null;
  }

  // set cookie
  function setCookie(cookieName,cookieValue,nDays) {
    var today = new Date(),
        expire = new Date();
    if (nDays==null || nDays==0) nDays=1;
    expire.setTime(today.getTime() + 3600000*24*nDays);
    // console.log('setting '+cookieName+' = '+escape(cookieValue));
    document.cookie = cookieName + "=" + escape(cookieValue) + "; expires=" + expire.toGMTString() + "; path=/";
  }

  // constructor
  function ExactTarget() {}

  // read the query string and set the proper cookies
  ExactTarget.prototype.init = function(){
    var qstr = document.location.search,
        thevars, i;
    qstr = qstr.substring(1,qstr.length);
    thevars = qstr.split("&");
    for(i=0;i<thevars.length;i++) {
      var cookiecase, e, j, l, jb, u, mid;
      cookiecase = thevars[i].split("=");
      switch(cookiecase[0]) {
        case "e":
          e = cookiecase[1];
          setCookie("EmailAddr",e,ExpireDays);
          break;
        case "j":
          j = cookiecase[1];
          setCookie("JobID",j,ExpireDays);
          break;
        case "l":
          l = cookiecase[1];
          setCookie("ListID",l,ExpireDays);
          break;
        case "jb":
          jb = cookiecase[1];
          setCookie("BatchID",jb,ExpireDays);
          break;
        case "u":
          u = cookiecase[1];
          setCookie("UrlID",u,ExpireDays);
          break;
        case "mid":
          mid = cookiecase[1];
          setCookie("MemberID",mid,ExpireDays);
          break;
        default:
          break;
      }
    }
  };

  ExactTarget.prototype.getTrackingUrl = function(linkalias, dataset){
    var endpoint = "https://click.exacttarget.com/conversion.aspx",
        convid="1",
        displayorder="1",
        jobid = getCookie("JobID"),
        emailaddr = getCookie("EmailAddr"),
        listid = getCookie("ListID"),
        batchid = getCookie("BatchID"),
        urlid = getCookie("UrlID"),
        memberid = getCookie("MemberID"),
        url = "";
    url += endpoint+"?xml=<system><system_name>tracking</system_name><action>conversion</action>";
    url += "<member_id>"+memberid+"</member_id>";
    url += "<job_id>"+jobid+"</job_id>";
    url += "<email>"+emailaddr+"</email>";
    url += "<list>"+listid+"</list>";
    url += "<BatchID>"+batchid+"</BatchID>";
    url += "<original_link_id>"+urlid+"</original_link_id>";
    url += "<conversion_link_id>"+convid+"</conversion_link_id>";
    url += "<link_alias>"+linkalias+"</link_alias>";
    url += "<display_order>"+displayorder+"</display_order>";
    url += "<data_set>"+dataset+"</data_set>";
    url += "</system>";
    return url;
  };

  // make a tracking image
  ExactTarget.prototype.track = function(linkalias, dataset){
    var url = this.getTrackingUrl(linkalias, dataset),
        img_string = "<img src='"+url+"' width='1' height='1'>";
    // console.log('Wrote tracking img: '+img_string);
    document.write(img_string);
  };

  return ExactTarget;

}());

var _et = new ExactTarget;
_et.init();
