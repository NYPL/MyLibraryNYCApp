import React from "react";

import { Link, DSProvider, TemplateAppContainer, Image, Logo} from '@nypl/design-system-react-components';

import nyplLogo from '../images/nypl.png'
import brooklynLibraryLogo from '../images/brooklyn_public_library.png'
import queensLibraryLogo from '../images/queens_public_library_v2.png'
import doeLogo from '../images/doe.png'


function Footer() {
  return (
    <div className="app-footer">
      <div className="app-footer-links">
        <Link id="nypl-footer-logo-link" marginLeft="s" href="http://nypl.org" type="dafault" attributes={{ target: '_blank'}} >
          <Logo name="nyplFullBlack" size="small" />
        </Link>

        <Link id="brooklyn-foooter-logo-link" marginLeft="s" href="http://www.brooklynpubliclibrary.org" type="dafault" attributes={{ target: '_blank'}} >
          <Image id="brooklyn-foooter-logo" size="small" src={brooklynLibraryLogo} />
        </Link>

        <Link id="queens-foooter-logo-link" marginLeft="s" href="http://www.queenslibrary.org" type="dafault" attributes={{ target: '_blank'}} >
          <Logo name="qplAltBlack" size="small" />
        </Link>

        <Link id="doe-foooter-logo-link" marginLeft="s" href="http://schools.nyc.gov" type="dafault" attributes={{ target: '_blank'}} >
          <Image id="doe-foooter-logo" size="small" src={doeLogo} />
        </Link>
      </div>
      <div id="mln-terms-conditions" className="appTermsConditions">
        <Link marginLeft="s" id="mln-terms" href="http://www.nypl.org/help/about-nypl/legal-notices/website-terms-and-conditions" target="_blank">Terms</Link>|
        <Link id="mln-privacy-policy" href="http://www.nypl.org/help/about-nypl/legal-notices/privacy-policy" target="_blank">Privacy Policy</Link>
      </div>
    </div>
  )
}

export default Footer;

