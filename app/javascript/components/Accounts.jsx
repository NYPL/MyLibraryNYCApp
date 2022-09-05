import React, { Component, useState, useEffect } from 'react';
import AppBreadcrumbs from "./AppBreadcrumbs";
import HaveQuestions from "./HaveQuestions";
import axios from 'axios';

import {
  Input, TextInput, List, Form, Button, FormRow, InputTypes, Label, FormField, 
  DSProvider, TemplateAppContainer, Select, Heading, Link, LinkTypes, Table, Notification, Pagination, Icon, ButtonGroup, Text, SkeletonLoader
} from '@nypl/design-system-react-components';

import {
  BrowserRouter as Router,
  Link as ReactRouterLink,
} from "react-router-dom";

export default function Accounts(props) {

  const [contact_email, setContactEmail] = useState("")
  const [current_user, setCurrentUser] = useState("")
  const [teacher_set, setTeacherSet] = useState("")
  const [school, setSchool] = useState("")
  const [alt_email, setAltEmail] = useState("")
  const [email, setEmail] = useState("")
  const [schools, setSchools] = useState("")
  const [school_id, setSchoolId] = useState("")
  const [holds, setHolds] = useState("")
  const [password, setPassword] = useState("")
  const [message, setMessage] = useState("")
  const [cancel_message, setCancelMessage] = useState("")
  const [cancel_button_display, SetCancelButtonDisplay] = useState("block")
  const [computedCurrentPage, setComputedCurrentPage] = useState(1)
  const [total_pages, setTotalPages] = useState("")
  const [ordersNotPresentMsg, setOrdersNotPresentMsg] = useState("")


  useEffect(() => {

    axios.defaults.headers.common['X-CSRF-TOKEN'] = document.querySelector("meta[name='csrf-token']").getAttribute("content")

    axios.get('/account', { params: { page: 1 } } ).then(res => {
      if (res.request.responseURL == "https://" + process.env.MLN_INFO_SITE_HOSTNAME + "/signin") {
        window.location = res.request.responseURL;
        return false;
      }
      else {
        let account_details = res.data.accountdetails
        setContactEmail(account_details.contact_email)
        setSchool(account_details.school)
        setEmail(account_details.email)
        setAltEmail(account_details.alt_email)
        setSchools(account_details.schools)
        setCurrentUser(account_details.current_user)
        setHolds(account_details.holds)
        setSchoolId(account_details.school.id)
        setPassword(account_details.current_password)
        setTotalPages(account_details.total_pages)
        setOrdersNotPresentMsg(account_details.ordersNotPresentMsg)
      }
    }).catch(function (error) {
        console.log("cancel order fail")
        console.log(error)
    })

  }, []);

  const handleSubmit = () => {
    event.preventDefault();
    axios.defaults.headers.common['X-CSRF-TOKEN'] = document.querySelector("meta[name='csrf-token']").getAttribute("content")
    axios.put('/users/', {
        user: { alt_email: alt_email, school_id: school_id, current_password: password }
     }).then(res => {
        if (res.data.status === "updated") {
          setMessage(res.data.message)
        }
      })
      .catch(function (error) {
       console.log(error)
    })
  }

  const handleAltEmail = (event) => {
    setAltEmail(event.target.value)
  }

  const handleSchool = event => {
    setSchool(event.target.value)
  }

  const Schools = () => {
    return Object.entries(schools).map((school, i) => {
      return (
        <option key={school[1]} value={school[1]}>{school[0]}</option>
      )
    }, this);
  }
  
  const HoldsDetails = () => {
    if (holds) {
      return holds.map((hold, index) => (
           [ orderCreatedLink(hold), hold["quantity"], hold["title"], statusLabel(hold), cancelButton(hold, index) ]
          )
        )
    }
  }

  const orderCreatedLink = (hold) => {
    return <Link whiteSpace="nowrap" href={"/ordered_holds/" + hold["access_key"]} > {hold["created_at"]} </Link>
  }

  const statusLabel = (hold) => {
    return hold["status_label"]
  }

  const cancelButton = (hold, index)  =>{
    if (hold["status"] === "new") {
      return <div id={"cancel-hold-button-"+index}> {orderCancelConfirmation(hold, index)} </div>
    } else if (hold["status"] === "cancelled"){
      return <div id={"order-ts-button-"+index}> {orderTeacherSet(hold, index)} </div>
    }
  }

  const cancelOrder = (value, access_key, cancel_button_index) => {
    setCancelMessage("")
    axios.defaults.headers.common['X-CSRF-TOKEN'] = document.querySelector("meta[name='csrf-token']").getAttribute("content")
    axios.put('/holds/'+ access_key, { hold_change: { status: 'cancelled' } 
     }).then(res => {
        if (res.request.responseURL == "https://" + process.env.MLN_INFO_SITE_HOSTNAME + "/signin") {
          window.location = res.request.responseURL;
          return false;
        } else {
          if (res.data.hold.status == "cancelled") {
            SetCancelButtonDisplay("none")
            setCancelMessage("Successfully Cancelled")

            let updatedHolds = holds.map( (obj, index) => {
             if(index === cancel_button_index) {
               return Object.assign({}, obj, {
                 status: "cancelled", status_label: "Cancelled"
               });
             }
             return obj;
          });
            setHolds(updatedHolds)
          }
        }
      })
      .catch(function (error) {
        console.log(error)
    })
  }

  const orderCancelConfirmation = (hold, index) => {
    return <div id={"cancel_"+ hold["access_key"]}>
    <ButtonGroup buttonWidth="full">
      <Button id="account-page-cancel-button" buttonType="noBrand"> 
        <Link className="accountPageCancelOrder" href={"/holds/" + hold["access_key"] + "/cancel"} > Cancel </Link>
      </Button>
    </ButtonGroup>
    </div>
  }

  const orderTeacherSet = (hold, index) => {
    return <div id={"cancel_"+ hold["access_key"]}>
    <ButtonGroup buttonWidth="full">
      <Button id="account-page-order-button" buttonType="secondary" whiteSpace="nowrap"> 
        <Link id="account-page-order-link"className="accountPageTeacherSetOrder" href={"/teacher_set_details/" + hold.teacher_set_id} > Order Again </Link>
      </Button>
     </ButtonGroup>
    </div>
  }

  const AccountUpdatedMessage = () => {
    if (message !== "") {
      return <Notification ariaLabel="Account Notification" id="account-details-notification"
        className="accountNotificationMsg"
        notificationType="announcement"
        icon={<Icon color="ui.black" iconRotation="rotate0" name="actionCheckCircle" size="small"/>}
        notificationContent={message}
      />
    }  
  }

  const OrderDetails = () => {
    return <>
      <Table
        columnHeaders={[
          'Order Placed',
          'Quantity',
          'Title',
          'Status',
          'Action'
        ]}
        showRowDividers={true}
        columnHeadersBackgroundColor="#F5F5F5"
        columnHeadersTextColor="\"
        tableData={HoldsDetails()}
        id="ts-order-details-list"
      />
    </>
  }

  const accountSkeletonLoader = () => {
    if (ordersNotPresentMsg === "" && holds.length <= 0) {
      return <SkeletonLoader
        contentSize={4}
        headingSize={1}
        imageAspectRatio="portrait"
        layout="row"
        showImage={false}
      />
    }
  }

  const displayOrders = () => {
    if (holds.length > 0) {
      return OrderDetails()
     } else if (ordersNotPresentMsg !== ""){
      return <Text marginTop="m" size="default">You have not yet placed any orders.</Text>
     }
  }

  const onPageChange = (page) => {
    setComputedCurrentPage(page);
    axios.defaults.headers.common['X-CSRF-TOKEN'] = document.querySelector("meta[name='csrf-token']").getAttribute("content")
    axios.get('/account', { params: { page: page } }).then(res => {
      if (res.request.responseURL == "https://" + process.env.MLN_INFO_SITE_HOSTNAME + "/signin") {
        window.location = res.request.responseURL;
        return false;
      }
      else {
        let account_details = res.data.accountdetails
        setContactEmail(account_details.contact_email)
        setSchool(account_details.school)
        setEmail(account_details.email)
        setAltEmail(account_details.alt_email)
        setSchools(account_details.schools)
        setCurrentUser(account_details.current_user)
        setHolds(account_details.holds)
        setSchoolId(account_details.school.id)
        setPassword(account_details.current_password)
        setTotalPages(account_details.total_pages)
        setOrdersNotPresentMsg(account_details.ordersNotPresentMsg)
      }
    }).catch(function (error) {
        console.log("cancel order fail")
        console.log(error)
    })
  };

  const userFirstName = () => {
    return current_user.first_name ? current_user.first_name : ""
  }

  return (
    <TemplateAppContainer
      breakout={<><AppBreadcrumbs />{ AccountUpdatedMessage() }</>}
      contentPrimary={
        <>
          <Heading id="account-user-name" level="three" text={'Hello, ' + userFirstName() } />
          <Form id="account-details-form">
            <FormField>
              <TextInput
                labelText="Your DOE Email Address"
                id="account-details-input"
                value={alt_email}
                onChange={handleAltEmail}
              />
            </FormField>
            <FormField>
              <Select id="ad-select-schools" labelText="Your School" value={school_id} showLabel onChange={handleSchool}>
                {Schools()}
              </Select>
            </FormField>
            <Button id="ad-submit-button" buttonType="noBrand" className="accountButton" onClick={handleSubmit}> Update Account Information </Button>
          </Form>
          <Heading marginTop="l" marginBottom="m" id="your-orders-text" size="tertiary" level="three" text='Orders' />
          {accountSkeletonLoader()}
          {displayOrders()}
          <Pagination marginTop="s" id="ad-pagination"className="accocuntOrderPagination" currentPage={1} onPageChange={onPageChange} pageCount={total_pages} />
        </>
      }
      contentSidebar={<div><HaveQuestions /></div>}
      sidebar="right"
  />)
}
