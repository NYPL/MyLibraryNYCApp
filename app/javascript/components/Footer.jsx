import React from "react";

import { Link, LinkTypes} from '@nypl/design-system-react-components';


function Footer() {
  return (
    <div className="app-footer">

        <Link href="http://nypl.org" type={LinkTypes.Default} attributes={{ target: '_blank'}} >
          <img className="nypl-footer" border="0" src="/assets/nypl.png"/>
        </Link>

        <Link href="http://www.brooklynpubliclibrary.org" type={LinkTypes.Default} attributes={{ target: '_blank'}} >
          <img className="nypl-footer" border="0" src="/assets/brooklyn_public_library.png"/>
        </Link>

        <Link href="http://www.queenslibrary.org" type={LinkTypes.Default} attributes={{ target: '_blank'}} >
          <img className="nypl-footer" border="0" src="/assets/queens_public_library_v2.png"/>
        </Link>

        <Link href="http://schools.nyc.gov" type={LinkTypes.Default} attributes={{ target: '_blank'}} >
          <img className="nypl-footer" border="0" src="/assets/doe.png"/>
        </Link>
      <br/>
      <br/>
      <a href="http://www.nypl.org/help/about-nypl/legal-notices/website-terms-and-conditions" target="_blank">Terms</a>
      &nbsp;|&nbsp;
      <a href="http://www.nypl.org/help/about-nypl/legal-notices/privacy-policy" target="_blank">Privacy Policy</a>
    </div>
  );
}

export default Footer;

