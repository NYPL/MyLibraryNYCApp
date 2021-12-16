import React from "react";

import { Link, LinkTypes, DSProvider, TemplateAppContainer, Image, Link as ReactRouterLink} from '@nypl/design-system-react-components';

import nyplLogo from '../images/nypl.png'
import brooklynLibraryLogo from '../images/brooklyn_public_library.png'
import queensLibraryLogo from '../images/queens_public_library_v2.png'
import doeLogo from '../images/doe.png'


function Footer() {
  return (
    <div className="app-footer">
      <div className="app-footer-links">
        <Link className="footerImage" href="http://nypl.org" type={LinkTypes.Default} attributes={{ target: '_blank'}} >
          <Image imageType="default" imageSize="small" src={nyplLogo} />
        </Link>

        <Link className="footerImage" href="http://www.brooklynpubliclibrary.org" type={LinkTypes.Default} attributes={{ target: '_blank'}} >
          <Image imageType="default" imageSize="small" src={brooklynLibraryLogo} />
        </Link>

        <Link className="footerImage" href="http://www.queenslibrary.org" type={LinkTypes.Default} attributes={{ target: '_blank'}} >
          <Image imageType="default" imageSize="small" src={queensLibraryLogo} />
        </Link>

        <Link className="footerImage" href="http://schools.nyc.gov" type={LinkTypes.Default} attributes={{ target: '_blank'}} >
          <Image imageType="default" imageSize="small" src={doeLogo} />
        </Link>
      </div>
      <div className="appTermsConditions">
        <a href="http://www.nypl.org/help/about-nypl/legal-notices/website-terms-and-conditions" target="_blank">Terms</a>
        &nbsp;|&nbsp;
        <a href="http://www.nypl.org/help/about-nypl/legal-notices/privacy-policy" target="_blank">Privacy Policy</a>
      </div>

    </div>
  )
}

export default Footer;

