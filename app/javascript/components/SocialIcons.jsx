import React from "react";
import { useColorModeValue } from "@nypl/design-system-react-components";
import { Link, Icon } from "@nypl/design-system-react-components";

export default function SocialIcons() {
  const socialMediaIconColor = useColorModeValue(
    "var(--nypl-colors-ui-black)",
    "var(--nypl-colors-dark-ui-typography-heading)"
  );

  return (
    <>
      <Link
        marginRight="xs"
        marginTop="s"
        type="action"
        target="_blank"
        href="https://twitter.com/mylibrarynyc/"
        aria-label="Visit our Twitter page"
      >
        <Icon
          title="Twitter icon"
          align="right"
          color={socialMediaIconColor}
          className="navBarIcon"
          decorative
          iconRotation="rotate0"
          id="social-twitter-icon-id"
          name="socialTwitter"
          size="large"
          type="default"
        />
      </Link>

      <Link
        type="action"
        target="_blank"
        href="https://www.instagram.com/mylibrarynyc/"
        aria-label="Visit our Instagram page"
      >
        <Icon
          title="Instagram icon"
          align="right"
          color={socialMediaIconColor}
          className="navBarIcon"
          decorative
          iconRotation="rotate0"
          id="social-instagram-icon-id"
          name="socialInstagram"
          size="large"
          type="default"
        />
      </Link>
    </>
  );
}
