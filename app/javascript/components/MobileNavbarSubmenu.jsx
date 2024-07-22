import React from "react";
import { Link as ReactRouterLink } from "react-router-dom";
import {
  Link,
  Icon,
  List,
  HorizontalRule,
} from "@nypl/design-system-react-components";

export default function MobileNavbarSubmenu() {
  return (
    <div className="navMenu-wrapper">
      <List
        type="ul"
        noStyling
        marginLeft="s"
        marginBottom="s"
        key="mobile-navbar-list-key"
      >
        <li marginTop="s">
          <ReactRouterLink className="mobileSubmenu" to="/signin">
            Sign in
          </ReactRouterLink>
          <HorizontalRule align="left" className="mobileHorizontalRule" />
        </li>
        <li>
          <ReactRouterLink className="mobileSubmenu" to="/contacts">
            Contact
          </ReactRouterLink>
          <HorizontalRule align="left" className="mobileHorizontalRule" />
        </li>

        <li>
          <ReactRouterLink className="mobileSubmenu" to="/faq">
            FAQ
          </ReactRouterLink>
          <HorizontalRule align="left" className="mobileHorizontalRule" />
        </li>

        <li>
          <ReactRouterLink
            className="mobileSubmenu"
            to="/participating-schools"
          >
            Participating Schools
          </ReactRouterLink>
          <HorizontalRule align="left" className="mobileHorizontalRule" />
        </li>

        <li
          id="mln-navbar-social-media-link"
          style={{ "margin-bottom": "16px" }}
          className="nav__menu-item socialMediaIcon"
        >
          <Link
            type="action"
            target="_blank"
            href="https://twitter.com/mylibrarynyc/"
          >
            <Icon
              align="right"
              color="ui.white"
              decorative
              iconRotation="rotate0"
              id="icon-id"
              name="socialTwitter"
              size="medium"
              type="default"
            />
          </Link>
          <Link
            type="action"
            target="_blank"
            href="https://www.instagram.com/mylibrarynyc/"
            marginLeft="s"
          >
            <Icon
              align="right"
              color="ui.white"
              decorative
              iconRotation="rotate0"
              id="icon-id"
              name="socialInstagram"
              size="medium"
              type="default"
            />
          </Link>
        </li>
      </List>
    </div>
  );
}
