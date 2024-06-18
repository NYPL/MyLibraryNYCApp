import React, { useState, useEffect } from "react";
import AppBreadcrumbs from "./AppBreadcrumbs";
import HaveQuestions from "./HaveQuestions/HaveQuestions";
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
  Label,
  Stack,
  useColorModeValue,
  useColorMode,
} from "@nypl/design-system-react-components";

import validator from "validator";

export default function Accounts() {
  const [currentUser, setCurrentUser] = useState("");
  const [altEmail, setAltEmail] = useState("");
  const [email, setEmail] = useState("");
  const [schools, setSchools] = useState("");
  const [schoolId, setSchoolId] = useState("");
  const [holds, setHolds] = useState("");
  const [password, setPassword] = useState("");
  const [message, setMessage] = useState("");
  const [totalPages, setTotalPages] = useState("");
  const [ordersNotPresentMsg, setOrdersNotPresentMsg] = useState("");
  const [altEmailIsvalid, setAltEmailIsvalid] = useState(false);
  const [notificationType, setNotificationType] = useState("announcement");
  const [notificationIcon, setNotificationIcon] = useState("actionCheckCircle");
  const [notificationIconColor, setNotificationIconColor] =
    useState("ui.black");
  const [displayNotification, setDisplayNotification] = useState("block");
  const tableHeaderBgColor = useColorModeValue(
    "ui.bg.default",
    "dark.ui.bg.default"
  );
  const tableHeaderColor = useColorModeValue(
    "var(--nypl-colors-ui-black)",
    "var(--nypl-colors-dark-ui-typography-heading)"
  );
  const { colorMode } = useColorMode();

  useEffect(() => {
    window.scrollTo(0, 0);
    document.title = "Account Details | MyLibraryNYC";
    axios.defaults.headers.common["X-CSRF-TOKEN"] = document
      .querySelector("meta[name='csrf-token']")
      .getAttribute("content");

    axios
      .get("/account", { params: { page: 1 } })
      .then((res) => {
        if (
          res.request.responseURL ===
          "https://" + env.MLN_INFO_SITE_HOSTNAME + "/signin"
        ) {
          window.location = res.request.responseURL;
          return false;
        } else {
          let accountDetails = res.data.accountdetails;
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

    if (altEmail !== "" && !validator.isEmail(altEmail)) {
      setAltEmailIsvalid(true);
      setDisplayNotification("none");
      return;
    } else {
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
          setMessage(res.data.message);
          setDisplayNotification("block");
          if (res.data.status === "updated") {
            setAltEmailIsvalid(false);
            setNotificationType("announcement");
            setNotificationIcon("actionCheckCircle");
            setNotificationIconColor("ui.black");
            if (altEmail === "") {
              setAltEmail(res.data.user.alt_email);
            }
          } else {
            setNotificationType("warning");
            setNotificationIcon("errorFilled");
            setNotificationIconColor("brand.primary");
          }
        })
        .catch(function (error) {
          console.log(error);
        });
    }
  };

  const handleAltEmail = (event) => {
    setAltEmail(event.target.value);
    if (event.target.value === "") {
      setAltEmailIsvalid(false);
    }
  };

  const handleSchool = (event) => {
    setSchoolId(event.target.value);
  };

  const Schools = () => {
    return Object.entries(schools).map((school, _i) => {
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
    return hold["status_label"] === 'Awaiting Review' ? 'Awaiting review' : hold["status_label"];
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

  const orderCancelConfirmation = (hold) => {
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

  const orderTeacherSet = (hold) => {
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
              className={`${colorMode} accountPageTeacherSetOrder`}
              href={"/teacher_set_details/" + hold.teacher_set_id}
            >
              {" "}
              Order again{" "}
            </Link>
          </Button>
        </ButtonGroup>
      </div>
    );
  };

  const AccountUpdatedMessage = () => {
    if (message !== "") {
      return (
        <div>
          <Notification
            style={{ display: displayNotification }}
            ariaLabel="Account Notification"
            id="account-details-notification"
            className="accountNotificationMsg"
            notificationType={notificationType}
            icon={
              <Icon
                color={notificationIconColor}
                iconRotation="rotate0"
                name={notificationIcon}
                size="small"
              />
            }
            notificationContent={message}
          />
        </div>
      );
    }
  };

  const OrderDetails = () => {
    return (
      <>
        <Table
          className="accountDetailsHeading"
          columnHeaders={[
            "Order placed",
            "Quantity",
            "Title",
            "Status",
            "Action",
          ]}
          showRowDividers={true}
          columnHeadersBackgroundColor={tableHeaderBgColor}
          columnHeadersTextColor={tableHeaderColor}
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
          "https://" + env.MLN_INFO_SITE_HOSTNAME + "/signin"
        ) {
          window.location = res.request.responseURL;
          return false;
        } else {
          let accountDetails = res.data.accountdetails;
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
      breakout={<AppBreadcrumbs />}
      contentTop={AccountUpdatedMessage()}
      contentPrimary={
        <>
          <Heading
            id="account-user-name"
            level="h2"
            size="heading3"
            text={"Hello, " + userFirstName()}
          />
          <Form id="account-details-form">
            <FormField>
              <Stack spacing="0" direction="column">
                <Label id="doe-email-address-text">
                  Your DOE email address
                </Label>
                {email && (
                  <Text id="doe-email-address-id" size="body2" marginTop="xs">
                    {email}
                  </Text>
                )}
              </Stack>
            </FormField>
            <FormField>
              <TextInput
                labelText="Preferred email address for reservation notifications"
                id="account-details-input"
                value={altEmail}
                onChange={handleAltEmail}
                invalidText="Please either enter a valid email address, or leave this field empty"
                isInvalid={altEmailIsvalid}
              />
            </FormField>
            <FormField>
              <Select
                id="ad-select-schools"
                labelText="Your school"
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
                Update account information{" "}
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
            size="heading5"
            level="h3"
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
