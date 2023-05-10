import React from "react";
import { Link, Heading, Icon, useColorModeValue } from "@nypl/design-system-react-components";

export default function HaveQuestions() {
  const socialMediaIconColor = useColorModeValue(
    "var(--nypl-colors-ui-black)",
    "var(--nypl-colors-dark-ui-typography-heading)"
  );

  return (
    <>
      <Heading
        id="heading-tertiary"
        level="two"
        size="tertiary"
        text="Have Questions?"
      />
      <div id="have-questions-links">
        <p className="visitOurText">
          Visit Our{" "}
          <Link id="home-faq-link" type="action" href="/faq">
            FAQ Page
          </Link>
        </p>
        <p>
          Or{" "}
          <Link id="home-contact-link" type="action" href="/contact">
            Contact Us
          </Link>
        </p>
        <p>
          <Link
            marginRight="xs"
            marginTop="s"
            type="action"
            target="_blank"
            href="https://twitter.com/mylibrarynyc/"
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
              aria-label="Visit our Twitter page"
            />
          </Link>

          <Link
            type="action"
            target="_blank"
            href="https://www.instagram.com/mylibrarynyc/"
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
              aria-label="Visit our Instagram page"
            />
          </Link>
        </p>
      </div>
    </>
  );
}
