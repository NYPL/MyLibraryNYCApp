import React, { useState, useEffect } from "react";
import AppBreadcrumbs from "./AppBreadcrumbs";
import HaveQuestions from "./HaveQuestions";
import axios from "axios";

import {
  TextInput,
  Form,
  Button,
  FormField,
  TemplateAppContainer,
  Select,
  Heading,
  Link,
  Table,
  Notification,
  Pagination,
  Icon,
  ButtonGroup,
  Text,
  SkeletonLoader,
  HorizontalRule,
} from "@nypl/design-system-react-components";

export default function Accounts() {
  const [currentUser, setCurrentUser] = useState("");
  const [school, setSchool] = useState("");
  const [altEmail, setAltEmail] = useState("");
  const [email, setEmail] = useState("");
  const [schools, setSchools] = useState("");
  const [schoolId, setSchoolId] = useState("");
  const [holds, setHolds] = useState("");
  const [password, setPassword] = useState("");
  const [message, setMessage] = useState("");
  const [totalPages, setTotalPages] = useState("");
  const [ordersNotPresentMsg, setOrdersNotPresentMsg] = useState("");

  useEffect(() => {
    window.scrollTo(0, 0);
    axios.defaults.headers.common["X-CSRF-TOKEN"] = document
      .querySelector("meta[name='csrf-token']")
      .getAttribute("content");

    axios
      .get("/account", { params: { page: 1 } })
      .then((res) => {
        if (
          res.request.responseURL ===
          "https://" + process.env.MLN_INFO_SITE_HOSTNAME + "/signin"
        ) {
          window.location = res.request.responseURL;
          return false;
        } else {
          let accountDetails = res.data.accountdetails;
          setSchool(accountDetails.school);
          setEmail(accountDetails.email);
          setAltEmail(accountDetails.alt_email);
          setSchools(accountDetails.schools);
          setCurrentUser(accountDetails.current_user);
          setHolds(accountDetails.holds);
          setSchoolId(accountDetails.school.id);
          setPassword(accountDetails.current_password);
          setTotalPages(accountDetails.total_pages);
          setOrdersNotPresentMsg(accountDetails.ordersNotPresentMsg);
        }
      })
      .catch(function (error) {
        console.log("cancel order fail");
        console.log(error);
      });
  }, []);

  const handleSubmit = () => {
    event.preventDefault();
    axios.defaults.headers.common["X-CSRF-TOKEN"] = document
      .querySelector("meta[name='csrf-token']")
      .getAttribute("content");
    axios
      .put("/users/", {
        user: {
          alt_email: altEmail,
          school_id: schoolId,
          current_password: password,
        },
      })
      .then((res) => {
        if (res.data.status === "updated") {
          setMessage(res.data.message);
        }
      })
      .catch(function (error) {
        console.log(error);
      });
  };

  const handleAltEmail = (event) => {
    setAltEmail(event.target.value);
  };

  const handleSchool = (event) => {
    setSchool(event.target.value);
    setSchoolId(event.target.value);
  };

  const Schools = () => {
    return Object.entries(schools).map((school, i) => {
      return (
        <option key={school[1]} value={school[1]}>
          {school[0]}
        </option>
      );
    }, this);
  };

  const HoldsDetails = () => {
    if (holds) {
      return holds.map((hold, index) => [
        orderCreatedLink(hold),
        hold["quantity"],
        hold["title"],
        statusLabel(hold),
        cancelButton(hold, index),
      ]);
    }
  };

  const orderCreatedLink = (hold) => {
    return (
      <Link whiteSpace="nowrap" href={"/ordered_holds/" + hold["access_key"]}>
        {" "}
        {hold["created_at"]}{" "}
      </Link>
    );
  };

  const statusLabel = (hold) => {
    return hold["status_label"];
  };

  const cancelButton = (hold, index) => {
    if (hold["status"] === "new") {
      return (
        <div id={"cancel-hold-button-" + index}>
          {" "}
          {orderCancelConfirmation(hold, index)}{" "}
        </div>
      );
    } else if (hold["status"] === "cancelled") {
      return (
        <div id={"order-ts-button-" + index}>
          {" "}
          {orderTeacherSet(hold, index)}{" "}
        </div>
      );
    }
  };

  const cancelOrder = (value, access_key, cancel_button_index) => {
    axios.defaults.headers.common["X-CSRF-TOKEN"] = document
      .querySelector("meta[name='csrf-token']")
      .getAttribute("content");
    axios
      .put("/holds/" + access_key, { hold_change: { status: "cancelled" } })
      .then((res) => {
        if (
          res.request.responseURL ===
          "https://" + process.env.MLN_INFO_SITE_HOSTNAME + "/signin"
        ) {
          window.location = res.request.responseURL;
          return false;
        } else {
          if (res.data.hold.status === "cancelled") {
            let updatedHolds = holds.map((obj, index) => {
              if (index === cancel_button_index) {
                return Object.assign({}, obj, {
                  status: "cancelled",
                  status_label: "Cancelled",
                });
              }
              return obj;
            });
            setHolds(updatedHolds);
          }
        }
      })
      .catch(function (error) {
        console.log(error);
      });
  };

  const orderCancelConfirmation = (hold, index) => {
    return (
      <div id={"cancel_" + hold["access_key"]}>
        <ButtonGroup buttonWidth="full">
          <Button id="account-page-cancel-button" buttonType="noBrand">
            <Link
              className="accountPageCancelOrder"
              href={"/holds/" + hold["access_key"] + "/cancel"}
            >
              {" "}
              Cancel{" "}
            </Link>
          </Button>
        </ButtonGroup>
      </div>
    );
  };

  const orderTeacherSet = (hold, index) => {
    return (
      <div id={"cancel_" + hold["access_key"]}>
        <ButtonGroup buttonWidth="full">
          <Button
            id="account-page-order-button"
            buttonType="secondary"
            whiteSpace="nowrap"
          >
            <Link
              id="account-page-order-link"
              className="accountPageTeacherSetOrder"
              href={"/teacher_set_details/" + hold.teacher_set_id}
            >
              {" "}
              Order Again{" "}
            </Link>
          </Button>
        </ButtonGroup>
      </div>
    );
  };

  const AccountUpdatedMessage = () => {
    if (message !== "") {
      return (
        <Notification
          ariaLabel="Account Notification"
          id="account-details-notification"
          className="accountNotificationMsg"
          notificationType="announcement"
          icon={
            <Icon
              color="ui.black"
              iconRotation="rotate0"
              name="actionCheckCircle"
              size="small"
            />
          }
          notificationContent={message}
        />
      );
    }
  };

  const OrderDetails = () => {
    return (
      <>
        <Table
          columnHeaders={[
            "Order Placed",
            "Quantity",
            "Title",
            "Status",
            "Action",
          ]}
          showRowDividers={true}
          columnHeadersBackgroundColor="var(--nypl-colors-ui-gray-x-light-cool)"
          columnHeadersTextColor="var(--nypl-colors-ui-black)"
          tableData={HoldsDetails()}
          id="ts-order-details-list"
        />
      </>
    );
  };

  const accountSkeletonLoader = () => {
    if (ordersNotPresentMsg === "" && holds.length <= 0) {
      return (
        <SkeletonLoader
          contentSize={4}
          headingSize={1}
          imageAspectRatio="portrait"
          layout="row"
          showImage={false}
        />
      );
    }
  };

  const displayOrders = () => {
    if (holds.length > 0) {
      return OrderDetails();
    } else if (ordersNotPresentMsg !== "") {
      return (
        <Text marginTop="m" size="default">
          You have not yet placed any orders.
        </Text>
      );
    }
  };

  const onPageChange = (page) => {
    axios.defaults.headers.common["X-CSRF-TOKEN"] = document
      .querySelector("meta[name='csrf-token']")
      .getAttribute("content");
    axios
      .get("/account", { params: { page: page } })
      .then((res) => {
        if (
          res.request.responseURL ===
          "https://" + process.env.MLN_INFO_SITE_HOSTNAME + "/signin"
        ) {
          window.location = res.request.responseURL;
          return false;
        } else {
          let accountDetails = res.data.accountdetails;
          setSchool(accountDetails.school);
          setEmail(accountDetails.email);
          setAltEmail(accountDetails.alt_email);
          setSchools(accountDetails.schools);
          setCurrentUser(accountDetails.current_user);
          setHolds(accountDetails.holds);
          setSchoolId(accountDetails.school.id);
          setPassword(accountDetails.current_password);
          setTotalPages(accountDetails.total_pages);
          setOrdersNotPresentMsg(accountDetails.ordersNotPresentMsg);
        }
      })
      .catch(function (error) {
        console.log("cancel order fail");
        console.log(error);
      });
  };

  const userFirstName = () => {
    return currentUser.first_name ? currentUser.first_name : "";
  };

  return (
    <TemplateAppContainer
      breakout={
        <>
          <AppBreadcrumbs />
          {AccountUpdatedMessage()}
        </>
      }
      contentPrimary={
        <>
          <Heading
            id="account-user-name"
            level="three"
            text={"Hello, " + userFirstName()}
          />
          <Form id="account-details-form">
            <FormField>
              <TextInput
                labelText="Your DOE Email Address"
                id="account-details-input"
                value={altEmail || email}
                onChange={handleAltEmail}
              />
            </FormField>
            <FormField>
              <Select
                id="ad-select-schools"
                labelText="Your School"
                value={schoolId}
                showLabel
                onChange={handleSchool}
              >
                {Schools()}
              </Select>
            </FormField>
            <ButtonGroup>
              <Button
                id="ad-submit-button"
                buttonType="noBrand"
                type="submit"
                onClick={handleSubmit}
              >
                {" "}
                Update Account Information{" "}
              </Button>
            </ButtonGroup>
          </Form>
          <HorizontalRule
            id="ad-detail-page-horizontal-rule-id"
            color="var(--nypl-colors-ui-bg-hover)"
            marginTop="l"
            height="2px"
          />
          <Heading
            marginTop="l"
            marginBottom="m"
            id="your-orders-text"
            size="tertiary"
            level="three"
            text="Orders"
          />
          {accountSkeletonLoader()}
          {displayOrders()}
          <Pagination
            marginTop="s"
            id="ad-pagination"
            className="accocuntOrderPagination"
            onClick={() => window.scrollTo({ top: 275 })}
            currentPage={1}
            onPageChange={onPageChange}
            pageCount={totalPages}
          />
        </>
      }
      contentSidebar={
        <div>
          <HaveQuestions />
        </div>
      }
      sidebar="right"
    />
  );
}
