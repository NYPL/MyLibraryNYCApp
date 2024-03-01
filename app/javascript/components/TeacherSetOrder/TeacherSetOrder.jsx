import React, { useState, useEffect } from "react";
import AppBreadcrumbs from "./../AppBreadcrumbs";
import HaveQuestions from "./../HaveQuestions/HaveQuestions";
import TeacherSetOrderDetails from "./../TeacherSetOrderDetails";
import axios from "axios";
import { useParams, useNavigate } from "react-router-dom";

import {
  Button,
  Heading,
  Link,
  Icon,
  TemplateAppContainer,
  HorizontalRule,
  useColorMode,
} from "@nypl/design-system-react-components";

export default function TeacherSetOrder(props) {
  const params = useParams();
  const navigate = useNavigate();
  const [hold, setHold] = useState(props.holddetails);
  const [teacherSet, setTeacherSet] = useState(props.teachersetdetails);
  const { colorMode } = useColorMode();

  useEffect(() => {
    window.scrollTo(0, 0);
    document.title = "Order Details | MyLibraryNYC";
    if (typeof hold === "string") {
      axios
        .get("/holds/" + params["access_key"])
        .then((res) => {
          if (
            res.request.responseURL ===
            "https://" + env.MLN_INFO_SITE_HOSTNAME + "/signin"
          ) {
            navigate(res.request.responseURL);
            return false;
          } else {
            setTeacherSet(res.data.teacher_set);
            setHold(res.data.hold);
            if (res.data.hold && res.data.hold.status === "cancelled") {
              document.title = "Order Cancelled | MyLibraryNYC";
            } else {
              document.title = "Order Details | MyLibraryNYC";
            }
          }
        })
        .catch(function (error) {
          console.log(error);
        });
    }
  }, []);

  const OrderMessage = () => {
    const orderMessage =
      "Your order has been received by our system and will be soon delivered to your school. Check your email inbox for further details.";
    const cancelledMessage = "The order below has been cancelled.";
    return hold && hold["status"] === "cancelled"
      ? cancelledMessage
      : orderMessage;
  };

  const showCancelButton = () => {
    return hold && hold.status === "cancelled" ? "none" : "block";
  };

  const CancelButton = () => {
    return (
      <div style={{ display: showCancelButton() }}>
        <Button
          id="order-cancel-button"
          className="cancel-button"
          buttonType="secondary"
          onClick={() => window.scrollTo({ top: 10 })}
        >
          <Link
            className={`${colorMode} cancelOrderButton`}
            href={"/holds/" + params["access_key"] + "/cancel"}
          >
            {" "}
            Cancel My Order{" "}
          </Link>
        </Button>
      </div>
    );
  };

  const confirmationMsg = () => {
    return hold && hold.status === "cancelled"
      ? "Cancel Order Confirmation"
      : "Order Confirmation";
  };

  return (
    <TemplateAppContainer
      breakout={<AppBreadcrumbs />}
      contentPrimary={
        <>
          <Heading
            id="order-confirmation-heading"
            level="two"
            size="secondary"
            text={confirmationMsg}
          />
          <HorizontalRule
            id="ts-detail-page-horizontal-rulel"
            className={`${colorMode} teacherSetHorizontal`}
          />
          {OrderMessage()}
          <TeacherSetOrderDetails
            teacherSetDetails={teacherSet}
            orderDetails={hold}
          />

          {CancelButton()}

          <Link
            marginTop="l"
            href="/teacher_set_data"
            id="ts-details-link-page"
            type="action"
          >
            <Icon
              name="arrow"
              iconRotation="rotate90"
              size="small"
              align="left"
            />
            Back to Search Teacher Sets Page
          </Link>
        </>
      }
      contentSidebar={<HaveQuestions />}
      sidebar="right"
    />
  );
}
