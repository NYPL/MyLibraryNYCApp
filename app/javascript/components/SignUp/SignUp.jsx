import React, { useState, useEffect } from "react";
import AppBreadcrumbs from "./../AppBreadcrumbs";
import HaveQuestions from "./../HaveQuestions/HaveQuestions";
import axios from "axios";
import {
  Button,
  Select,
  TextInput,
  TemplateAppContainer,
  Text,
  FormField,
  Form,
  Notification,
  Checkbox,
  HorizontalRule,
  Heading,
  ButtonGroup,
  useColorMode,
} from "@nypl/design-system-react-components";
import validator from "validator";
import { useNavigate } from "react-router-dom";

export default function SignUp(props) {
  const navigate = useNavigate();
  const [email, setEmail] = useState("");
  const [errorEmailMsg, setErrorEmailMsg] = useState("");
  const [errorAltEmailMsg, setAltEmailErrorMsg] = useState("");
  const [alt_email, setAltEmail] = useState("");
  const [first_name, setFirstName] = useState("");
  const [last_name, setLastName] = useState("");
  const [school_id, setSchoolId] = useState("");
  const [password, setPassword] = useState("");
  const [active_schools, setActiveSchools] = useState("");
  const [firstNameIsValid, setFirstNameIsValid] = useState(false);
  const [firstNameErrorMsg, setFirstNameErrorMsg] = useState("");
  const [lastNameIsValid, setLastNameIsValid] = useState(false);
  const [lastNameErrorMsg, setLastNameErrorMsg] = useState("");
  const [passwordIsValid, setPasswordIsValid] = useState(false);
  const [passwordErrorMsg, setPasswordErrorMsg] = useState("");
  const [schoolIsValid, setSchoolIsValid] = useState(false);
  const [schoolErrorMsg, setSchoolErrorMsg] = useState("");
  const [emailIsInvalid, setEmailIsInvalid] = useState(false);
  const [altEmailIsvalid, setAltEmailIsvalid] = useState(false);
  const [news_letter_error, setNewsLetterError] = useState("");
  const [show_news_letter_error, setShowNewsLetterError] = useState(false);
  const [isCheckedVal, setIsCheckedVal] = useState(false);
  const [isDisabled, setIsDisabled] = useState(false);
  const [serverError, setServerError] = useState("");
  const [serverErrorIsValid, setServerErrorIsValid] = useState(false);
  const [allowed_email_patterns, setAllowedEmailPatterns] = useState([]);
  const { colorMode } = useColorMode();
  
  useEffect(() => {
    document.title = "Sign Up | MyLibraryNYC";
    if (process.env.NODE_ENV !== "test") {
      window.scrollTo(0, 0);
    }
    axios
      .get("/sign_up_details")
      .then((res) => {
        setActiveSchools(res.data.activeSchools);
        setAllowedEmailPatterns(res.data.emailMasks);
      })
      .catch(function (error) {
        console.log(error);
      });
  }, []);

  const redirectToTeacherSetPage = () => {
    window.scrollTo(0, 0);
    navigate("/teacher_set_data", { state: { userSignedIn: true } });
  };

  const handleSubmit = (event) => {
    event.preventDefault();   
    const news_email = isCheckedVal? alt_email || email : ""

    if (handleValidation()) {
      axios
        .post("/users", {
          user: {
            email: email,
            alt_email: alt_email,
            first_name: first_name,
            last_name: last_name,
            password: password,
            school_id: school_id,
            news_letter_email: news_email,
          },
        })
        .then((res) => {
          if (res.data.status === "created") {
            props.handleLogin(true);
            props.handleSignedUpMsg(res.data.message);
            redirectToTeacherSetPage();
            return false;
          } else {
            if (
              res.data.message.alt_email &&
              res.data.message.alt_email.length > 0
            ) {
              setAltEmailErrorMsg(res.data.message.alt_email[0]);
              setAltEmailIsvalid(true);
              setIsDisabled(true);
            }

            if (res.data.message.email && res.data.message.email.length > 0) {
              setErrorEmailMsg(res.data.message.email[0]);
              setEmailIsInvalid(true);
              setIsDisabled(true);
            }
            if (
              res.data.message.first_name &&
              res.data.message.first_name.length > 0
            ) {
              setFirstNameErrorMsg(res.data.message.first_name[0]);
              setFirstNameIsValid(true);
              setIsDisabled(true);
            }
            if (
              res.data.message.last_name &&
              res.data.message.last_name.length > 0
            ) {
              setLastNameErrorMsg(res.data.message.last_name[0]);
              setLastNameIsValid(true);
              setIsDisabled(true);
            }
            if (
              res.data.message.school_id &&
              res.data.message.school_id.length > 0
            ) {
              setSchoolErrorMsg(res.data.message.school_id[0]);
              setSchoolIsValid(true);
              setIsDisabled(true);
            }
            if (
              res.data.message.password &&
              res.data.message.password.length > 0
            ) {
              setPasswordErrorMsg(res.data.message.password[0]);
              setPasswordIsValid(true);
              setIsDisabled(true);
            }
            if (
              res.data.status === 500 &&
              res.data.message.error &&
              res.data.message.error.length > 0
            ) {
              setServerError(res.data.message.error[0]);
              setIsDisabled(true);
              setServerErrorIsValid(true);
            }
          }
        })
        .catch(function (error) {
          console.log(error);
        });
    }
  };

  const validateEmailDomain = (email) => {
    let formIsValid = true;
    let domain = email.split("@");
    let email_domain_is_allowed = allowed_email_patterns.includes(
      "@" + domain[1]
    );

    if (email && !email_domain_is_allowed) {
      let msg =
        'Enter a valid email address ending in "@schools.nyc.gov" or another participating school domain.';
      setErrorEmailMsg(msg);
      setEmailIsInvalid(true);
      setIsDisabled(true);
      formIsValid = false;
    } else {
      setErrorEmailMsg("");
      setNewsLetterError("");
      setShowNewsLetterError(false);
      setEmailIsInvalid(false);
      setIsDisabled(false);
    }

    if (email) {
      axios
        .get("/check_email", { params: { email: email } })
        .then((res) => {
          if (res.data.statusCode === 409) {
            setErrorEmailMsg(
              "An account is already registered to this email address. Contact help@mylibrarynyc.org if you need assistance."
            );
            setEmailIsInvalid(true);
            setIsDisabled(true);
            formIsValid = false;
          }
        })
        .catch(function (error) {
          console.log(error);
        });
    }
    return formIsValid;
  };

  const validateAltEmailDomain = (alt_email) => {
    if (alt_email && !validator.isEmail(alt_email)) {
      let msg = "Preferred email address is invalid";
      setAltEmailErrorMsg(msg);
      setAltEmailIsvalid(true);
      setIsDisabled(true);
      setIsCheckedVal(false);
    } else {
      setAltEmailErrorMsg("");
      setAltEmailIsvalid(false);
      setIsDisabled(false);
      setIsCheckedVal(false);
      setNewsLetterError("");
      setShowNewsLetterError(false);
    }
  };

  const handleValidation = () => {
    let formIsValid = true;

    if (!email) {
      formIsValid = false;
      setEmailIsInvalid(true);
      setIsDisabled(true);
      setErrorEmailMsg("Email can not be empty");
    } else {
      formIsValid = validateEmailDomain(email);
    }

    if (!alt_email) {
      setAltEmailErrorMsg("");
    } else {
      validateAltEmailDomain(alt_email);
    }

    if (!first_name) {
      formIsValid = false;
      setFirstNameIsValid(true);
      setIsDisabled(true);
      setFirstNameErrorMsg("First name can not be empty");
    }

    if (first_name && typeof first_name === "string") {
      if (!first_name.match(/^[a-z ,.'()-]+$/i)) {
        formIsValid = false;
        setFirstNameIsValid(true);
        setIsDisabled(true);
        setFirstNameErrorMsg(
          "First name can only contain letters and characters like '-.,()"
        );
      }
    }

    if (!last_name) {
      setLastNameIsValid(true);
      setIsDisabled(true);
      formIsValid = false;
      setLastNameErrorMsg("Last name can not be empty");
    }

    if (last_name && typeof last_name === "string") {
      if (!last_name.match(/^[a-z ,.'()-]+$/i)) {
        formIsValid = false;
        setLastNameIsValid(true);
        setIsDisabled(true);
        setLastNameErrorMsg(
          "Last name can only contain letters and characters like '-.,()"
        );
      }
    }

    if (!password) {
      formIsValid = false;
      setPasswordIsValid(true);
      setIsDisabled(true);
      setPasswordErrorMsg("Password can not be empty");
    }

    if (password && typeof password === "string") {
      if (!isStrongPassword(password)) {
        formIsValid = false;
        setPasswordIsValid(true);
        setIsDisabled(true);
        setPasswordErrorMsg(
          "Your password must be at least 8 characters, include a mixture of both uppercase and lowercase letters, include a mixture of letters and numbers, have at least one special character except period (.) and please do not repeat a character three times, e.g. aaaatf54 or repeating a pattern, e.g. abcabcab"
        );
      }
    }

    if (!school_id) {
      setSchoolIsValid(true);
      setIsDisabled(true);
      setSchoolErrorMsg("Please select a school");
      formIsValid = false;
    }

    showNotifications();

    if (!formIsValid) {
      setServerErrorIsValid(false);
    }
    return formIsValid;
  };

  const handleEmail = (field, e) => {
    setEmail(e.target.value);
    setEmailIsInvalid(false);
    setIsDisabled(false);
    setErrorEmailMsg("");
  };

  const handleAltEmail = (field, e) => {
    setAltEmailIsvalid(false);
    setIsDisabled(false);
    setAltEmailErrorMsg("");
    setAltEmail(e.target.value);

    if (e.target.value && !validator.isEmail(e.target.value)) {
      setAltEmailIsvalid(false); // need to revisit
      setIsDisabled(true);
      setIsCheckedVal(false);
      setAltEmailErrorMsg("");
    } else {
      setAltEmailIsvalid(false);
      setIsDisabled(false);
      setIsCheckedVal(false);
      setNewsLetterError("");
      setShowNewsLetterError(false);
    }
  };

  const handleFirstName = (field, e) => {
    setFirstNameIsValid(false);
    setIsDisabled(false);
    setFirstName(e.target.value);
  };

  const handleLastName = (field, e) => {
    setLastName(e.target.value);
    setLastNameIsValid(false);
    setIsDisabled(false);
  };

  const handlePassword = (field, e) => {
    setPassword(e.target.value);
    setPasswordIsValid(false);
    setIsDisabled(false);
  };

  const handleSchool = (field, e) => {
    setSchoolIsValid(false);
    setIsDisabled(false);
    setSchoolId(e.target.value);

    if (!e.target.value) {
      setSchoolIsValid(true);
      setIsDisabled(true);
      setSchoolErrorMsg("Please select a school");
    }
  };

  const Schools = () => {
    let schools = Object.entries(
      Object.assign({ "-- Select A School -- ": "" }, active_schools)
    );
    return schools.map((school) => {
      return (
        <option key={school[1]} value={school[1]}>
          {school[0]}
        </option>
      );
    }, this);
  };

  const showNotifications = () => {
    if (
      errorEmailMsg ||
      errorAltEmailMsg ||
      firstNameErrorMsg ||
      lastNameErrorMsg ||
      passwordErrorMsg ||
      serverError
    ) {
      return "display_block signUpMessage";
    } else {
      return "display_none signUpMessage";
    }
  };

  const showErrors = () => {
    return errorEmailMsg ||
      errorAltEmailMsg ||
      firstNameErrorMsg ||
      lastNameErrorMsg ||
      passwordErrorMsg ||
      serverError
      ? "block"
      : "none";
  };

  const showErrorMessage = () => {
    return errorEmailMsg ||
      errorAltEmailMsg ||
      firstNameErrorMsg ||
      lastNameErrorMsg ||
      passwordErrorMsg ||
      serverError
      ? "block"
      : "none";
  };

  const verifyNewsLetterEmailInSignUpPage = (event) => {
    const initial_check = isCheckedVal;

    setIsCheckedVal(!initial_check);
    const news_letter_email = alt_email || email;

    if (event.target.value === 1 && news_letter_email === undefined) {
      setNewsLetterError("Please enter a valid email address");
      setShowNewsLetterError(true);
      setIsDisabled(true);
      setIsCheckedVal(false);
    } else {
      setNewsLetterError("");
      setShowNewsLetterError(false);
      setIsDisabled(false);
    }

    if (news_letter_email !== undefined) {
      axios
        .post(
          "/news_letter/validate_news_letter_email_from_user_sign_up_page",
          { email: news_letter_email }
        )
        .then((res) => {
          if (event.target.value === 1 && res.data["error"] !== undefined) {
            setNewsLetterError(res.data["error"]);
            setShowNewsLetterError(true);
            setIsCheckedVal(false);
          } else if (
            event.target.value === 1 &&
            res.data["success"] !== undefined
          ) {
            setNewsLetterError("");
            setShowNewsLetterError(false);
            setIsDisabled(false);
            setIsCheckedVal(!initial_check);
          }
        })
        .catch(function (error) {
          console.log(error);
        });
    }
  };

  const isStrongPassword = (password) => {
    if (
      password &&
      password.length >= 8 &&
      password.match(/[a-z]/g) &&
      password.match(/[A-Z]/g) &&
      !password.match(/[.\s]/g) &&
      password.match(/[0-9]/g) &&
      password.match(/[^a-zA-Z.\d]/g) &&
      !password.match(/(.)\1{2,}/g) &&
      !password.match(/(..+)\1{1,}/g)
    ) {
      return true;
    } else {
      return false;
    }
  };

  const showNotificationContent = () => {
    return (
      <div style={{ display: showErrorMessage() }}>
        <Notification
          ariaLabel="Signup Error Notifications"
          id="sign-up-error-notifications"
          className={showNotifications()}
          notificationType="warning"
          notificationContent={
            <Text
              id="sign-up-error-notifications-text"
              noSpace
              className="signUpMessage"
            >
              {" "}
              {showCommonErrorMsg()}{" "}
            </Text>
          }
        />
      </div>
    );
  };

  const showCommonErrorMsg = () => {
    if (serverErrorIsValid && serverError) {
      return "We've encountered an error. Please try again later or email help@mylibrarynyc.org for assistance.";
    } else {
      return "Some of your information needs to be updated before your account can be created. See the fields highlighted below.";
    }
  };

  return (
    <TemplateAppContainer
      breakout={<AppBreadcrumbs />}
      contentPrimary={
        <>
          <Heading
            id="sign-up-heading-id"
            level="two"
            size="secondary"
            text="Sign Up"
          />
          <HorizontalRule
            id="ts-detail-page-horizontal-rulel"
            marginTop="s"
            className={`${colorMode} teacherSetHorizontal`}
          />

          <div style={{ display: showErrors() }}>
            {showNotificationContent()}
          </div>
          <Form id="sign-up-form">
            <FormField>
              <TextInput
                id="sign-up-email"
                isRequired
                marginTop="l"
                showoptreqlabel="true"
                labelText="Your DOE Email Address"
                value={email}
                onChange={handleEmail.bind(this, "email")}
                invalidText={errorEmailMsg}
                isInvalid={emailIsInvalid}
                helperText="Email address must end with @schools.nyc.gov or a participating school domain."
              />
            </FormField>
            <FormField>
              <TextInput
                id="sign-up-preferred-email"
                showoptreqlabel="true"
                labelText="Preferred email address"
                value={alt_email}
                invalidText={errorAltEmailMsg}
                isInvalid={altEmailIsvalid}
                onChange={handleAltEmail.bind(this, "alt_email")}
              />
            </FormField>
            <FormField>
              <TextInput
                id="sign-up-first-name"
                isRequired
                showoptreqlabel="true"
                labelText="First Name"
                value={first_name}
                invalidText={firstNameErrorMsg}
                isInvalid={firstNameIsValid}
                onChange={handleFirstName.bind(this, "first_name")}
              />
            </FormField>
            <FormField>
              <TextInput
                id="sign-up-last-name"
                isRequired
                showoptreqlabel="true"
                labelText="Last Name"
                value={last_name}
                invalidText={lastNameErrorMsg}
                isInvalid={lastNameIsValid}
                onChange={handleLastName.bind(this, "last_name")}
              />
            </FormField>
            <FormField>
              <Select
                id="sign-up-select-schools"
                labelText="Your School"
                value={school_id}
                showLabel
                isRequired
                showoptreqlabel="true"
                invalidText={schoolErrorMsg}
                isInvalid={schoolIsValid}
                onChange={handleSchool.bind(this, "school_id")}
              >
                {Schools()}
              </Select>
            </FormField>
            <FormField>
              <TextInput
                id="sign-up-password"
                isRequired
                showoptreqlabel="true"
                labelText="Password"
                value={password}
                invalidText={passwordErrorMsg}
                isInvalid={passwordIsValid}
                onChange={handlePassword.bind(this, "password")}
                type="password"
                helperText={
                  <>
                    <Text noSpace>
                      We encourage you to select a strong password that
                      includes: at least 8 characters, a mixture of uppercase
                      and lowercase letters, a mixture of letters and numbers,
                      and at least one special character except period (.).
                      Please ensure you do not use common patterns such as
                      consecutively repeating a character three times, e.g.
                      aaaatf54 or repeating a pattern, e.g. abcabcab.
                    </Text>
                  </>
                }
              />
            </FormField>
            <Checkbox
              id="news-letter-checkbox"
              invalidText={news_letter_error}
              isInvalid={show_news_letter_error}
              labelText="Select if you would like to receive the MyLibraryNYC email newsletter (we will use your alternate email if supplied above)"
              isChecked={isCheckedVal}
              name="sign_up_page"
              onChange={verifyNewsLetterEmailInSignUpPage}
              showHelperInvalidText
              showLabel
              value="1"
            />
            <FormField>
              <ButtonGroup>
                <Button
                  id="sign-up-button-id"
                  onClick={handleSubmit}
                  buttonType="noBrand"
                  isDisabled={isDisabled}
                >
                  {" "}
                  Sign Up{" "}
                </Button>
              </ButtonGroup>
            </FormField>
          </Form>
        </>
      }
      contentSidebar={<HaveQuestions />}
      sidebar="right"
    />
  );
}
