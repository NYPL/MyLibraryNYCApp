import React, { useState, useEffect } from "react";
import AppBreadcrumbs from "./../AppBreadcrumbs";
import HaveQuestions from "./../HaveQuestions";
import axios from "axios";
import {
  Button,
  TextInput,
  TemplateAppContainer,
  Icon,
  Notification,
  Text,
  Heading,
  HorizontalRule,
  Link,
  useColorModeValue,
  useColorMode,
} from "@nypl/design-system-react-components";
import validator from "validator";
import { useNavigate, useLocation } from "react-router-dom";

export default function SignIn(props) {
  const navigate = useNavigate();
  const location = useLocation();
  const [email, setEmail] = useState("");
  const [invali_email_msg, setInvalidEmailMsg] = useState("");
  const [isInvalid, setIsInvalid] = useState(false);
  const { colorMode } = useColorMode();
  
  const actionHelpOutlineColor = useColorModeValue(
    "var(--nypl-colors-ui-black)",
    "var(--nypl-colors-dark-ui-typography-heading)"
  );

  useEffect(() => {
    if (process.env.NODE_ENV !== "test") {
      window.scrollTo(0, 0);
    }
    if (props.userSignedIn && location.pathname === "/signin") {
      navigate("/account_details");
      return false;
    }
  }, []);

  const handleEmail = (event) => {
    setEmail(event.target.value);
    setIsInvalid(false);
  };

  const handleSubmit = (event) => {
    event.preventDefault();
    if (email === "") {
      setInvalidEmailMsg("Please enter a valid email address");
      setIsInvalid(true);
      return false;
    }

    if (!validator.isEmail(email)) {
      setInvalidEmailMsg("Please enter a valid email address");
      setIsInvalid(true);
      return false;
    }

    axios.defaults.headers.common["X-CSRF-TOKEN"] = document
      .querySelector("meta[name='csrf-token']")
      .getAttribute("content");
    axios
      .post("/users/login", { user: { email: email } })
      .then((res) => {
        if (res.data.logged_in) {
          props.handleLogin(true);
          props.handleSignInMsg(res.data.sign_in_msg, true);
          props.hideSignInMessage(false);
          console.log(res.data.user_return_to);
          console.log(location);
          navigate("/" + res.data.user_return_to, {
            state: { userSignedIn: true },
          });
          return false;
        } else {
          setInvalidEmailMsg("Please enter a valid email address");
          setIsInvalid(true);
        }
      })
      .catch(function (error) {
        console.log(error);
      });
  };

  return (
    <TemplateAppContainer
      breakout={<AppBreadcrumbs />}
      contentPrimary={
        <>
          <Heading
            id="sign-in-heading-id"
            level="two"
            size="secondary"
            text="Sign In"
          />
          <HorizontalRule
            id="ts-detail-page-horizontal-rule-id"
            marginTop="s"
            className={`${colorMode} teacherSetHorizontal`}
          />

          <TextInput
            isRequired
            id="sign-in-text-input"
            marginTop="xs"
            type="text"
            labelText="Your DOE Email Address"
            placeholder="Enter email address"
            onChange={handleEmail}
            invalidText={invali_email_msg}
            helperText="Ex:jsmith@schools.nyc.gov"
            isInvalid={isInvalid}
          />
          <Button
            id="sign-in-button"
            marginTop="l"
            className="signin-button"
            size="medium"
            buttonType="noBrand"
            onClick={handleSubmit}
          >
            Sign In
          </Button>

          <Text id="not-registered-text" marginTop="xs" noSpace size="default">
            Not Registered? Please
            <Link
              href="/signup"
              id="sign-up-link"
              type="action"
              marginLeft="xxs"
            >
              Sign Up
            </Link>
          </Text>
          <Notification
            marginTop="l"
            marginLeft="0"
            notificationType="announcement"
            icon={
              <Icon
                color={actionHelpOutlineColor}
                align="right"
                iconRotation="rotate0"
                name="actionHelpOutline"
                size="medium"
                type="default"
              />
            }
            notificationContent={
              <>
                Your DOE email address will look like{" "}
                <b>jsmith@schools.nyc.gov</b>, consisting of your first initial
                plus your last name. It may also contain a numeral after your
                name (
                <b>jsmith2@schools.nyc.gov, jsmith3@schools.nyc.gov, etc.</b>).
                Even if you do not check your DOE email regularly, please use it
                to sign in. You can provide an alternate email address later for
                delivery notifications and other communications.
              </>
            }
          />
        </>
      }
      contentSidebar={<HaveQuestions />}
      sidebar="right"
    />
  );
}
