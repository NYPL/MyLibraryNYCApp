import React, { Component, useState } from 'react';
import { List, Card, CardContent, StatusBadge, CardHeading, Link, Heading } from '@nypl/design-system-react-components';
import { ReactRouterLink } from "react-router-dom";
import { titleCase } from "title-case";
import { compareAsc, format } from 'date-fns'
import dateFormat from 'dateformat';


export default function TeacherSetOrderDetails(props) {

  const [mesage, setMessage] = useState([]);
  const orderDetails = props.orderDetails;
  const STATUS_LABEL = {
    'new': 'Awaiting Review',
    'pending': 'Order processed and awaiting next available set',
    'closed': 'Fulfilled',
    'cancelled': 'Cancelled'
  }

  const teacherSetDetails = () => {
    if (props.teacherSetDetails) {
      let ts = props.teacherSetDetails
      let title = ts.title? ts.title : " "
      let availability_status_badge =  (ts.availability === "available") ? "medium" : "low"
      let availability = ts.availability !== undefined ? ts.availability : ""
      let suitabilities_string = ts.suitabilities_string ? suitabilities_string : ""
      console.log(suitabilities_string)
      return <div>
          <Card id="book-page-ts-card-details" layout="row" imageAlt="Alt text" aspectRatio="square" size="xxsmall">
            <CardHeading level="four" id="ts-order-details">
              <Link  href={"/teacher_set_details/" + ts.id}  to={"/teacher_set_details/" + ts.id}>{ts.title}</Link>
            </CardHeading>
            <CardHeading level="six"id="ts-suitabilities">{ts.suitabilities_string}</CardHeading>
            <CardContent id="book-page-ts-availability"> 
              <StatusBadge level={availability_status_badge}>{titleCase(ts.availability)}</StatusBadge>
            </CardContent>
            <CardContent id="book-page-ts-description"> {ts.description} </CardContent>
          </Card>
      </div>
    }
  }

  const teacherSetOrderDetails = () => {
    let orderCancellled = ""
    let orderUpdatedDate = ""
    let showCancelledDate = "display_none"

    if (orderDetails && orderDetails["status"] == "cancelled"){
      orderCancellled = "Order Cancelled"
      orderUpdatedDate = dateFormat(orderDetails["updated_at"], "dddd, mmmm d, yyyy")
      showCancelledDate = "display_block"
    }

    return <List marginTop="l" id="order-confirmation-list-details" title="Order Details" type="dl">
        <dt>
          Teacher Set
        </dt>
        <dd>
          {teacherSetDetails()}
        </dd>
        <dt>
          Quantity
        </dt>
        <dd>
          {orderDetails["quantity"]}
        </dd>
        <dt>
          Order Placed
        </dt>
        <dd>
          {dateFormat(orderDetails["created_at"], "dddd, mmmm d, yyyy")}
        </dd>
        <dt>
          Status
        </dt>
        <dd>
          {STATUS_LABEL[orderDetails["status"]]}
        </dd>
        <dt className={showCancelledDate}>
          {orderCancellled}
        </dt>
        <dd className={showCancelledDate}>
          {orderUpdatedDate}
        </dd>
      </List>
  }

  return (
    teacherSetOrderDetails()
  )
}
