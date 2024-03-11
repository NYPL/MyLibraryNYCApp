import React, { useState, useEffect } from "react";
import AppBreadcrumbs from "./AppBreadcrumbs";
import HaveQuestions from "./HaveQuestions/HaveQuestions";
import TeacherSetOrderDetails from "./TeacherSetOrderDetails";
import axios from "axios";
import {
  Button,
  Heading,
  Link,
  TextInput,
  Label,
  HStack,
  TemplateAppContainer,
  HorizontalRule,
  useColorMode,
} from "@nypl/design-system-react-components";
import { useParams, useNavigate } from "react-router-dom";

export default function TeacherSetOrder() {
  const params = useParams();
  const navigate = useNavigate();
  const [access_key] = useState(params["id"]);
  const [hold, setHold] = useState("");
  const [teacher_set, setTeacherSet] = useState("");
  const [comment, setComment] = useState("");
  const { colorMode } = useColorMode();

  useEffect(() => {
    document.title = "Cancel Order | MyLibraryNYC";
    window.scrollTo(0, 0);
    axios({ method: "get", url: "/holds/" + params["id"] + "/cancel_details" })
      .then((res) => {
        setTeacherSet(res.data.teacher_set);
        setHold(res.data.hold);
      })
      .catch(function (error) {
        console.log(error);
      });
  }, []);

  const handleCancelComment = (event) => {
    setComment(event.target.value);
  };

  const handleSubmit = (event) => {
    event.preventDefault();
    axios
      .put("/holds/" + access_key, {
        hold_change: { status: "cancelled", comment: comment },
      })
      .then((res) => {
        if (
          res.request.responseURL ===
          "https://" + env.MLN_INFO_SITE_HOSTNAME + "/signin"
        ) {
          window.location = res.request.responseURL;
          return false;
        } else {
          navigate("/ordered_holds/" + access_key);
        }
      })
      .catch(function (error) {
        console.log(error);
      });
  };

  const cancelConfirmation = () => {
    if (hold["status"] !== "cancelled") {
      return (
        <>
          <Heading
            marginTop="l"
            id="ts-cancellation-confirmation-text"
            level="h3"
            size="tertiary"
            text="Confirm Cancellation"
          />
          <TextInput
            id="ts-cancel-order-button"
            labelText="Reason for cancelling order (optional)"
            type="textarea"
            defaultValue={comment}
            showLabel
            showRequiredLabel={false}
            textInputType="default"
            onChange={handleCancelComment}
          />
          <Label
            marginTop="m"
            htmlFor="id-of-input-element"
            id="confirm-teacher-set-order-label"
          >
            Are you sure you want to cancel your teacher set order?
          </Label>
          <HStack spacing="s" onClick={() => window.scrollTo(0, 0)}>
            <Button
              id="ts-cancel-button-id"
              buttonType="noBrand"
              onClick={handleSubmit}
            >
              {" "}
              Cancel My Order{" "}
            </Button>
            <Button
              id="keep-my-order-button"
              className="cancel-button"
              buttonType="secondary"
            >
              <Link
                className={`${colorMode} cancelOrderButton`}
                href={"/ordered_holds/" + access_key}
              >
                {" "}
                No, keep my order{" "}
              </Link>
            </Button>
          </HStack>
        </>
      );
    }
  };

  return (
    <TemplateAppContainer
      breakout={<AppBreadcrumbs />}
      contentPrimary={
        <>
          <Heading
            id="ts-cancellation-confirmation-text"
            level="h2"
            size="secondary"
            text="Cancel Order"
          />
          <HorizontalRule
            id="ts-cancel-order-horizontal=line"
            className={`${colorMode} teacherSetHorizontal`}
          />
          <div>
            Review your order details below and verify this is the order you
            would like cancel.
          </div>
          <TeacherSetOrderDetails
            teacherSetDetails={teacher_set}
            orderDetails={hold}
          />
          {cancelConfirmation()}
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
