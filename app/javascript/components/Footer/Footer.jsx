import React from "react";
import {
  Link,
  Logo,
  Center,
  useNYPLBreakpoints,
  VStack,
  HStack,
  useColorModeValue,
  Box,
} from "@nypl/design-system-react-components";

function Footer() {
  const { isLargerThanMobile } = useNYPLBreakpoints();
  const footerBgColor = useColorModeValue("ui.bg.default", "dark.ui.bg.default");
  const nyplFullLogo = useColorModeValue("nyplFullBlack", "nyplFullWhite");
  const bplLogo = useColorModeValue("bplBlack", "bplWhite");
  const qplAltLogo = useColorModeValue("qplAltBlack", "qplAltWhite");
  const doeLogo = useColorModeValue("nycdoeBlack", "nycdoeWhite");
  
  const footerLinks = () => {
    return (
      <>
        <a
          id="nypl-footer-logo-link"
          href="http://nypl.org"
          attributes={{ target: "_blank" }}
        >
          <Logo
            decorative
            id="nypl-footer-logo-id"
            name={nyplFullLogo}
            size="small"
          />
        </a>

        <Link
          id="brooklyn-foooter-logo-link"
          href="http://www.brooklynpubliclibrary.org"
          attributes={{ target: "_blank" }}
        >
          <Logo
            decorative
            id="brooklyn-foooter-logo-id"
            name={bplLogo}
            size="small"
          />
        </Link>

        <Link
          id="queens-foooter-logo-link"
          href="http://www.queenslibrary.org"
          attributes={{ target: "_blank" }}
        >
          <Logo
            decorative
            id="queens-foooter-logo-id"
            name={qplAltLogo}
            size="small"
          />
        </Link>
        <Link
          id="doe-foooter-logo-link"
          href="http://schools.nyc.gov"
          attributes={{ target: "_blank" }}
        >
          <Logo
            decorative
            id="doe-foooter-logo-id"
            name={doeLogo}
            size="small"
          />
        </Link>
      </>
    );
  };

  const footerData = () => {
    if (isLargerThanMobile) {
      return <HStack spacing="xxl">{footerLinks()}</HStack>;
    } else {
      return <VStack spacing="m">{footerLinks()}</VStack>;
    }
  };

  return (
    <Box className="app-footer" bg={footerBgColor}>
      <Center id="mln-footer-data" paddingTop="xxl">
        {footerData()}
      </Center>
      <Center paddingBottom="xxl">
        <Link
          id="mln-terms"
          color="var(--nypl-colors-ui-black)"
          href="http://www.nypl.org/help/about-nypl/legal-notices/website-terms-and-conditions"
          target="_blank"
          margin="s"
        >
          Terms
        </Link>
        |
        <Link
          id="mln-privacy-policy"
          color="var(--nypl-colors-ui-black)"
          href="http://www.nypl.org/help/about-nypl/legal-notices/privacy-policy"
          target="_blank"
          margin="s"
        >
          Privacy Policy
        </Link>
      </Center>
    </Box>
  );
}

export default Footer;
