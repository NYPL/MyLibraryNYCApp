import React from "react";
import {
  List,
  Card,
  CardContent,
  StatusBadge,
  CardHeading,
  Link,
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
        ts.availability === "available" ? "medium" : "low";
      let availability = ts.availability !== undefined ? ts.availability : "";
      let suitabilitiesString = ts.suitabilities_string
        ? ts.suitabilities_string
        : "";

      return (
        <div>
          <Card
            id="book-page-ts-card-details"
            layout="row"
            imagealt="Alt text"
            aspectratio="square"
            size="xxsmall"
          >
            <CardHeading level="four" id="ts-order-details">
              <Link
                href={"/teacher_set_details/" + ts.id}
                to={"/teacher_set_details/" + ts.id}
              >
                {ts.title}
              </Link>
            </CardHeading>
            <CardHeading level="six" id="ts-suitabilities">
              {suitabilitiesString}
            </CardHeading>
            <CardContent id="book-page-ts-availability">
              <StatusBadge level={availabilityStatusBadge}>
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

  const teacherSetOrderDetails = () => {
    let orderCancellled = "";
    let orderUpdatedDate = "";
    let showCancelledDate = "display_none";

    if (orderDetails && orderDetails["status"] === "cancelled") {
      orderCancellled = "Order Cancelled";
      orderUpdatedDate = dateFormat(
        orderDetails["updated_at"],
        "dddd, mmmm d, yyyy"
      );
      showCancelledDate = "display_block";
    }

    return (
      <List
        marginTop="l"
        id="order-confirmation-list-details"
        key="order-confirmation-list-details-key"
        title={<Heading level="h3" size="heading5">Order Details</Heading>}
        type="dl"
      >
        <dt>Teacher Set</dt>
        <dd>{teacherSetDetails()}</dd>
        <dt>Quantity</dt>
        <dd>{orderDetails["quantity"]}</dd>
        <dt>Order Placed</dt>
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
