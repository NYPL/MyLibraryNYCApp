import React, { useState, useEffect } from "react";
import axios from "axios";
import { Notification } from "@nypl/design-system-react-components";
import ReactParser from "html-react-parser";

function Banner() {
  const [bannerText, setBannerText] = useState("");
  const [bannerTextFound, setBannerTextFound] = useState("");

  useEffect(() => {
    if (env.RAILS_ENV !== "test") {
      window.scrollTo(0, 0);
    }
    axios
      .get("/mln_banner_message")
      .then((res) => {
        setBannerText(res.data.bannerText);
        setBannerTextFound(res.data.bannerTextFound);
      })
      .catch(function (error) {
        console.log(error);
      });
  }, []);

  const bannerMessage = () => {
    if (bannerText !== undefined && bannerTextFound) {
      return (
        <>
          <Notification
            ariaLabel="Banner Notification"
            id="banner-notification"
            notificationType="announcement"
            className="bannerMessage"
            isCentered
            showIcon={false}
            dismissible
            notificationContent={
              <div className="hrefLink">{ReactParser(bannerText)}</div>
            }
          />
        </>
      );
    } else {
      return <></>;
    }
  };

  return bannerMessage();
}
export default Banner;
