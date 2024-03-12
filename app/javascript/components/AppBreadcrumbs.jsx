import React from "react";
import {
  Breadcrumbs,
  Heading,
  Hero,
  useColorModeValue,
} from "@nypl/design-system-react-components";

export default function AppBreadcrumbs() {
  const heroBgColor = useColorModeValue(
    "var(--nypl-colors-brand-primary)",
    "var(--nypl-colors-dark-ui-bg-hover)"
  );
  const locationPath = window.location.pathname.split(/\/|\?|&|=|\./g)[1];
  const breadcrumbsUrl = (locationPath) => {
    let urls = [{ url: "//" + env.MLN_INFO_SITE_HOSTNAME, text: "Home" }];
    let locationPathname = window.location.pathname;

    if (
      ["ordered_holds", "teacher_set_details", "book_details"].includes(
        locationPath
      )
    ) {
      locationPathname = "/teacher_set_data";
    } else if (["signup", "signin"].includes(locationPath)) {
      locationPathname = "/account_details";
    }

    urls.push({
      url: "//" + window.location.hostname + locationPathname,
      text: HeroDataValue(locationPath),
    });

    if (
      [
        "signup",
        "signin",
        "ordered_holds",
        "teacher_set_details",
        "book_details",
        "holds",
      ].includes(locationPath)
    ) {
      urls.push({
        url: "//" + window.location.hostname + window.location.pathname,
        text: BreadcrumbsDataValue(locationPath),
      });
    }
    return urls;
  };

  const BreadcrumbsDataValue = (levelString) => {
    switch (levelString) {
      case "participating-schools":
        return "Participating schools";
      case "faq":
        return "Frequently Asked Questions";
      case "contact":
        return "Contacts";
      case "teacher_set_data":
        return "Teacher Sets";
      case "teacher_set_details":
        return "Teacher Sets";
      case "ordered_holds":
        return "Order Confirmation";
      case "holds":
        return "Order Confirmation";
      case "book_details":
        return "Book Details";
      case "signup":
        return "Sign Up";
      case "signin":
        return "Sign In";
      case "home":
        return "Calendar Event";
      default:
        return levelString;
    }
  };

  const HeroDataValue = (levelString) => {
    switch (levelString) {
      case "participating-schools":
        return "Participating schools";
      case "faq":
        return "Frequently Asked Questions";
      case "contact":
        return "Contact";
      case "teacher_set_data":
        return "Teacher Sets";
      case "teacher_set_details":
        return "Teacher Sets";
      case "ordered_holds":
        return "Teacher Sets";
      case "holds":
        return "Teacher Sets";
      case "account_details":
        return "My Account & Orders";
      case "book_details":
        return "Book Details";
      case "signup":
        return "Account";
      case "signin":
        return "Account";
      case "home":
        return "Calendar Event";
      case "newsletter_confirmation":
        return "Newsletter Confirmation";
      default:
        return "Home";
    }
  };

  return (
    <>
      <Breadcrumbs
        id={"mln-breadcrumbs-" + locationPath}
        breadcrumbsData={breadcrumbsUrl(locationPath)}
        breadcrumbsType="booksAndMore"
      />
      <Hero
        heroType="tertiary"
        backgroundColor={heroBgColor}
        heading={
          <Heading
            level="h1"
            color="ui.white"
            id={"hero-" + locationPath}
            text={HeroDataValue(locationPath)}
          />
        }
      />
    </>
  );
}
