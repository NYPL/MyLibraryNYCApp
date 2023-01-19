import React, { useState, useEffect } from "react";
import AppBreadcrumbs from "./AppBreadcrumbs";
import axios from "axios";
import {
  TemplateAppContainer,
  Text,
  SkeletonLoader,
} from "@nypl/design-system-react-components";

const NewsletterConfirmation = () => {
  const [success, setSuccess] = useState("");
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    let timeoutId = "";
    if (isLoading) {
      timeoutId = setInterval(() => {
        setIsLoading(false);
      }, 4000);
    }
    return () => {
      clearInterval(timeoutId);
    };
  }, [isLoading]);

  useEffect(() => {
    const key = new URLSearchParams(location.search).get("key");
    window.scrollTo(0, 0);
    axios
      .get("/home/newsletter_confirmation_msg/", { params: { key: key } })
      .then((res) => {
        setSuccess(res.data.success);
      })
      .catch(function (error) {
        console.log(error);
      });
  }, []);

  const NewsletterConfirmationMsg = () => {
    if (isLoading) {
      return (
        <SkeletonLoader
          className="teacher-set-details-skeleton-loader"
          contentSize={3}
          headingSize={0}
          imageAspectRatio="square"
          layout="column"
          showImage={false}
          width="900px"
          key={"news-letter-skeleton-loader"}
        />
      );
    } else {
      if (success !== "") {
        if (success) {
          return (
            <>
              <Text isBold size="default">
                MyLibraryNYC Newsletter Subscription Confirmed
              </Text>
              <Text>
                Thank you for subscribing to the MyLibraryNYC newsletter. Your
                email has been confirmed.
              </Text>
            </>
          );
        } else {
          return (
            <>
              <Text isBold size="default">
                MyLibraryNYC Newsletter Subscription Unsuccessful
              </Text>
              <Text>
                Unfortunately there was a problem subscribing to the
                MyLibraryNYC Newsletter. Please try subscribing again at{" "}
                <a href="https://www.mylibrarynyc.org/">www.mylibrarynyc.org</a>{" "}
                or contact{" "}
                <a href="mailto:help@mylibrarynyc.org">help@mylibrarynyc.org</a>
                .
              </Text>
            </>
          );
        }
      } else {
        return <></>;
      }
    }
  };

  return (
    <TemplateAppContainer
      breakout={<AppBreadcrumbs />}
      contentPrimary={NewsletterConfirmationMsg()}
      contentSidebar={<></>}
      sidebar="right"
    />
  );
};

export default NewsletterConfirmation;
