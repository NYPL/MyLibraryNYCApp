import React from "react";
import {
  List,
  Card,
  CardContent,
  StatusBadge,
  CardHeading,
  Link,
  Heading,
} from "@nypl/design-system-react-components";
import { titleCase } from "title-case";
import dateFormat from "dateformat";

export default function TeacherSetOrderDetails(props) {
  const orderDetails = props.orderDetails;

  const STATUS_LABEL = {
    new: "Awaiting Review",
    pending: "Order processed and awaiting next available set",
    closed: "Fulfilled",
    cancelled: "Cancelled",
  };

  if (orderDetails === undefined) {
    return null;
  }

  const teacherSetDetails = () => {
    if (props.teacherSetDetails) {
      let ts = props.teacherSetDetails;
      let availabilityStatusBadge =
        ts.availability === "available" ? "Informative" : "Neutral";
      let availability = ts.availability !== undefined ? ts.availability : "";
      let suitabilitiesString = ts.suitabilities_string
        ? ts.suitabilities_string
        : "";

      return (
        <div>
          <Card id="book-page-ts-card-details" layout="row">
            <CardHeading level="h4" id="ts-order-details">
              <Link
                href={"/teacher_set_details/" + ts.id}
                to={"/teacher_set_details/" + ts.id}
              >
                {ts.title}
              </Link>
            </CardHeading>
            <CardHeading level="h5" id="ts-suitabilities">
              {suitabilitiesString}
            </CardHeading>
            <CardContent id="book-page-ts-availability">
              <StatusBadge type={availabilityStatusBadge}>
                {titleCase(availability)}
              </StatusBadge>
            </CardContent>
            <CardContent id="book-page-ts-description">
              {" "}
              {ts.description}{" "}
            </CardContent>
          </Card>
        </div>
      );
    }
  };

  const adobeAnalyticsForCancelOrder = () => {
    // Push the event data to the Adobe Data Layer
    window.adobeDataLayer = window.adobeDataLayer || [];
    window.adobeDataLayer.push({
      event: "virtual_page_view",
      page_name: "mylibrarynyc|order-cancelled",
      site_section: "Order",
    });

    // Dynamically create and insert the script tag for Adobe Launch
    const script = document.createElement("script");
    script.src = env.ADOBE_LAUNCH_URL; // assuming you are using a bundler that supports environment variables
    script.async = true;
    document.head.appendChild(script);
  };

  const teacherSetOrderDetails = () => {
    let orderCancellled = "";
    let orderUpdatedDate = "";
    let showCancelledDate = "display_none";

    if (orderDetails && orderDetails["status"] === "cancelled") {
      orderCancellled = "Order cancelled";
      orderUpdatedDate = dateFormat(
        orderDetails["updated_at"],
        "dddd, mmmm d, yyyy"
      );
      showCancelledDate = "display_block";
      if (env.RAILS_ENV !== "test" && env.RAILS_ENV !== "development") {
        {
          adobeAnalyticsForCancelOrder();
        }
      }
    }

    return (
      <List
        marginTop="l"
        id="order-confirmation-list-details"
        key="order-confirmation-list-details-key"
        title={
          <Heading level="h3" size="heading5">
            Order details
          </Heading>
        }
        type="dl"
      >
        <dt>Teacher set</dt>
        <dd>{teacherSetDetails()}</dd>
        <dt>Quantity</dt>
        <dd>{orderDetails["quantity"]}</dd>
        <dt>Order placed</dt>
        <dd>{dateFormat(orderDetails["created_at"], "dddd, mmmm d, yyyy")}</dd>
        <dt>Status</dt>
        <dd>{STATUS_LABEL[orderDetails["status"]]}</dd>
        <dt className={showCancelledDate}>{orderCancellled}</dt>
        <dd className={showCancelledDate}>{orderUpdatedDate}</dd>
      </List>
    );
  };

  return teacherSetOrderDetails();
}
