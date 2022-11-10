import React, { useState, useEffect } from "react";
import AppBreadcrumbs from "./AppBreadcrumbs";
import HaveQuestions from "./HaveQuestions";
import axios from "axios";
import {
  TemplateAppContainer,
  Text,
  Notification,
  List,
  Link,
} from "@nypl/design-system-react-components";


export default function PageNotFound(props) {

  const pageNotFoundMsg = () => {
    return <>
      <Notification marginBottom="l" notificationType="warning" notificationContent={<>
        The page you are looking for does not exist.
      </>} />
      <Text>We’re sorry, the page you requested may have moved or it no longer exists. Please make sure the link you are using is correct.</Text>
      <Text>To continue using our site, you can:</Text>
      <List id="nypl-list" title="" type="ul">
        <li>
          Go to the <Link id="page-not-found-homepage-link" type="action" href="/">homepage</Link>
        </li>
        <li>
          Use the site menu to find what you need
        </li>
        <li>
          <Link id="page-not-found-contact-link" type="action" href="/contact">
            Contact us{" "}
          </Link> if you need more help
        </li>
      </List>
    </>
  }

  return (
    <TemplateAppContainer
      breakout={<AppBreadcrumbs />}
      contentPrimary={pageNotFoundMsg()}
      contentSidebar={<HaveQuestions />}
      sidebar="right"
    />
  )
}