import React from "react";
import HaveQuestions from "./../HaveQuestions/HaveQuestions";
import {
  TemplateAppContainer,
  Text,
  Notification,
  List,
  Link,
  Breadcrumbs,
  Hero,
  Heading,
} from "@nypl/design-system-react-components";

export default function PageNotFound() {
  const pageNotFoundMsg = () => {
    return (
      <>
        <Notification
          marginBottom="l"
          notificationType="warning"
          notificationContent={
            <>The page you are looking for does not exist.</>
          }
        />
        <Text marginLeft="s" data-testid="page-not-found-error-msg-1">
          We’re sorry, the page you requested may have moved or it no longer exists. Please make sure the link you are using is correct.
        </Text>
        <Text marginLeft="s" data-testid="page-not-found-error-msg-2">To continue using our site, you can:</Text>
        <List
          id="nypl-list"
          key="nypl-list-key"
          title=""
          type="ul"
        >
          <li>
            Go to the{" "}
            <Link id="page-not-found-homepage-link" type="action" href="/">
              homepage
            </Link>
          </li>
          <li>Use the site menu to find what you need</li>
          <li>
            <Link
              id="page-not-found-contact-link"
              type="action"
              href="/contact"
            >
              Contact us{" "}
            </Link>{" "}
            if you need more help
          </li>
        </List>
      </>
    );
  };

  return (
    <TemplateAppContainer
      breakout={
        <>
          <Breadcrumbs
            id={"mln-breadcrumbs-error-page"}
            breadcrumbsData={[
              { url: "//" + env.MLN_INFO_SITE_HOSTNAME, text: "Home" },
              {
                url: "//" + window.location.hostname + "/*",
                text: "404 Error",
              },
            ]}
            breadcrumbsType="booksAndMore"
          />
          <Hero
            heroType="tertiary"
            backgroundColor="var(--nypl-colors-brand-primary)"
            heading={
              <Heading
                level="h1"
                size='primary'
                id="mln-404-error-page"
                text="Page Not Found"
              />
            }
          />
        </>
      }
      contentPrimary={pageNotFoundMsg()}
      contentSidebar={<HaveQuestions />}
      sidebar="right"
    />
  );
}
