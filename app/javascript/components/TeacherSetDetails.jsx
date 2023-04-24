import React, { useState, useEffect } from "react";
import HaveQuestions from "./HaveQuestions/HaveQuestions";
import ShowBookImage from "./ShowBookImage";
import {
  Link as ReactRouterLink,
  useParams,
  useNavigate,
} from "react-router-dom";
import { titleCase } from "title-case";
import AnchorLink from "react-anchor-link-smooth-scroll";

import axios from "axios";
import {
  Button,
  Select,
  Heading,
  Image,
  Flex,
  Spacer,
  List,
  Link,
  TemplateAppContainer,
  Text,
  Form,
  FormField,
  SimpleGrid,
  ButtonGroup,
  Box,
  HorizontalRule,
  StatusBadge,
  VStack,
  Icon,
  Breadcrumbs,
  Hero,
  Notification,
  useNYPLBreakpoints,
  Accordion,
  SkeletonLoader,
  useColorModeValue,
  useColorMode,
} from "@nypl/design-system-react-components";

import mlnImage from "../images/mln.svg";

export default function TeacherSetDetails(props) {
  const params = useParams();
  const navigate = useNavigate();
  const [allowedQuantities, setAllowedQuantities] = useState([]);
  const [teacherSet, setTeacherSet] = useState("");
  const [books, setBooks] = useState([]);
  const [quantity, setQuantity] = useState("1");
  const [teacherSetNotes, setTeacherSetNotes] = useState([]);
  const [errorMessage, setErrorMessage] = useState("");
  const { isLargerThanMobile } = useNYPLBreakpoints();
  const [isLoading, setIsLoading] = useState(true);
  const heroBgColor = useColorModeValue(
    "var(--nypl-colors-brand-primary)",
    "var(--nypl-colors-dark-ui-bg-hover)"
  );
  const tsOrderBoxBgColor = useColorModeValue(
    "var(--nypl-colors-ui-gray-x-light-cool)",
    "var(--nypl-colors-dark.ui.bg.default)"
  );
  const tsOrderTextColor = useColorModeValue(
    "var(--nypl-colors-ui-black)",
    "var(--nypl-colors-dark-ui-typography-heading)"
  );
  const { colorMode } = useColorMode();

  useEffect(() => {
    setIsLoading(true);
  }, [books.cover_uri]);

  useEffect(() => {
    let timeoutId = "";
    if (isLoading) {
      timeoutId = setInterval(() => {
        setIsLoading(false);
      }, 500);
    }
    return () => {
      clearInterval(timeoutId);
    };
  }, [isLoading]);

  useEffect(() => {
    window.scrollTo(0, 0);
    axios.defaults.headers.common["X-CSRF-TOKEN"] = document
      .querySelector("meta[name='csrf-token']")
      .getAttribute("content");
    axios
      .get("/teacher_sets/" + params["id"])
      .then((res) => {
        setAllowedQuantities(res.data.allowed_quantities);
        setTeacherSet(res.data.teacher_set);
        setBooks(res.data.books);
        setTeacherSetNotes(res.data.teacher_set_notes);
      })
      .catch(function (error) {
        console.log(error);
        console.error(error);
      });
  }, []);

  const handleQuantity = (event) => {
    setQuantity(event.target.value);
  };

  const handleSubmit = (event) => {
    event.preventDefault();
    axios.defaults.headers.common["X-CSRF-TOKEN"] = document
      .querySelector("meta[name='csrf-token']")
      .getAttribute("content");
    axios
      .post("/holds", {
        teacher_set_id: params["id"],
        query_params: { quantity: quantity },
      })
      .then((res) => {
        if (res.request.responseURL.includes("/signin")) {
          window.location = res.request.responseURL;
          return false;
        } else {
          if (res.data.status === "created") {
            props.handleTeacherSetOrderedData(res.data.hold, teacherSet);
            navigate("/ordered_holds/" + res.data.hold["access_key"]);
          } else {
            setErrorMessage(res.data.message);
          }
        }
      })
      .catch(function (error) {
        console.log(error);
      });
  };

  const teacherSetTitle = () => {
    return <>{teacherSet["title"]}</>;
  };

  const TeacherSetDescription = () => {
    if (teacherSet["description"]) {
      return (
        <Text noSpace marginTop="xs" id="ts-page-desc">
          {teacherSet["description"]}
        </Text>
      );
    } else {
      return <></>;
    }
  };

  const ACopies = () => {
    if (teacherSet["available_copies"] !== undefined) {
      return teacherSet["available_copies"];
    } else {
      return "";
    }
  };

  const TotalCopies = () => {
    if (teacherSet["total_copies"] !== undefined) {
      return teacherSet["total_copies"];
    } else {
      return "";
    }
  };

  const AvailableCopies = () => {
    return (
      <div color="var(--nypl-colors-ui-black)">
        {ACopies()} of {TotalCopies()} Available
      </div>
    );
  };

  const BooksCount = () => {
    return (
      <div>
        {books.length > 1
          ? books.length + " Titles"
          : books.length >= 1
          ? books.length + " Title"
          : ""}
      </div>
    );
  };

  const TeacherSetBooks = () => {
    return books.map((data, index) => {
      if (isLoading) {
        return (
          <SkeletonLoader
            className="teacher-set-details-skeleton-loader"
            contentSize={0}
            headingSize={0}
            imageAspectRatio="square"
            layout="column"
            showImage
            width="189px"
            key={"ts-books-skeletonLoader-" + index}
          />
        );
      } else {
        return (
          <ReactRouterLink
            onClick={() => window.scrollTo(0, 0)}
            id={"ts-books-" + index}
            key={"ts-books-key-" + index}
            to={"/book_details/" + data.id}
            style={{ display: "grid", backgroundColor: "#F5F5F5" }}
          >
            {BookImage(data)}
          </ReactRouterLink>
        );
      }
    });
  };

  const fallBackImageData = (book, fallbackImg) => {
    return (
      <ShowBookImage
        book={book}
        src={book.cover_uri}
        fallbackImage={fallbackImg}
      />
    );
  };

  const fallbackImg = (book) => {
    return (
      <Box
        bg="var(--nypl-colors-ui-gray-x-light-cool)"
        width="189px"
        height="189px"
      >
        {book.title}
      </Box>
    );
  };

  const BookImage = (data) => {
    if (data.cover_uri) {
      return fallBackImageData(data, fallbackImg(data));
    } else {
      return (
        <Image
          title={data.title}
          id={"ts-books-" + data.id}
          src={mlnImage}
          className="bookImageTop"
          aspectRatio="square"
          size="default"
          alt={data.title}
        />
      );
    }
  };

  const TeacherSetNotesContent = () => {
    return teacherSetNotes.map((note, i) => {
      return (
        <div id={"ts-notes-content-" + i} key={"ts-notes-content-key-" + i}>
          {note.content}
        </div>
      );
    });
  };

  const teacherSetUnAvailableMsg = () => {
    return (
      <Text width="m" size="caption" color={tsOrderTextColor}>
        <b>This Teacher Set is unavailable.</b>{" "}
        <i>
          As it is currently being used by other educators, please allow 60 days
          or more for availability. If you would like to be placed on the wait
          list for this Teacher Set, contact us at
        </i>{" "}
        <Link
          type="action"
          target="_blank"
          className={`${colorMode} hrefBlackColor`}
          href="mailto:help@mylibrarynyc.org"
        >
          help@mylibrarynyc.org.
        </Link>
      </Text>
    );
  };

  const UnableToOrderAdditionalTeacherSetsMsg = () => {
    return (
      <Text width="m" size="caption">
        <b>Unable to order additional Teacher Sets.</b>{" "}
        <i>
          You have{" "}
          <Link
            className={`${colorMode} hrefBlackColor`}
            href="/account_details"
            id="ts-page-account-details-link"
            type="action"
            target="_blank"
          >
            requested
          </Link>{" "}
          the maximum allowed quantity of this Teacher Set. If you need more
          copies of this Teacher Set, contact us at
        </i>
        <Link
          type="action"
          target="_blank"
          href="mailto:help@mylibrarynyc.org"
          className={`${colorMode} hrefBlackColor`}
        >
          help@mylibrarynyc.org.
        </Link>
      </Text>
    );
  };

  const OrderTeacherSets = () => {
    if (teacherSet && teacherSet.available_copies <= 0) {
      return teacherSetUnAvailableMsg();
    } else if (allowedQuantities.length <= 0) {
      return UnableToOrderAdditionalTeacherSetsMsg();
    } else {
      return (
        <div>
          <Form gap="grid.xs" id="ts-order-form">
            <FormField id="ts-order-field">
              <Select
                id="ts-order-allowed-quantities"
                labelText=""
                onChange={handleQuantity}
                value={quantity}
              >
                {allowedQuantities.map((item, i) => {
                  return (
                    <option
                      id={"ts-quantity-" + i}
                      key={"ts-quantity-key-" + i}
                      value={item}
                    >
                      {item}
                    </option>
                  );
                }, this)}
              </Select>
              <Button
                id="ts-order-submit"
                buttonType="noBrand"
                onClick={handleSubmit}
              >
                {" "}
                Place Order{" "}
              </Button>
            </FormField>
          </Form>
          <Text isItalic size="caption" marginTop="s" color={tsOrderTextColor}>
            Note: Available Teacher Sets will deliver to your school within 2
            weeks. For Teacher Sets that are currently in use by other
            educators, please allow 60 days or more for delivery. If you need
            materials right away, contact us at{" "}
            <a
              className={`${colorMode} hrefBlackColor`}
              target="_blank"
              href="mailto:help@mylibrarynyc.org"
              rel="noreferrer"
              color={tsOrderTextColor}
            >
              help@mylibrarynyc.org.
            </a>
          </Text>
        </div>
      );
    }
  };

  const truncateTitle = (str, n, useWordBoundary) => {
    if (str.length <= n) {
      return str;
    }
    const subString = str.substr(0, n - 1); // the original check
    return (
      (useWordBoundary
        ? subString.substr(0, subString.lastIndexOf(" "))
        : subString) + "..."
    );
  };

  const breadcrumbTitle = (title) => {
    if (title.length >= 60) {
      return truncateTitle(title, 60, true);
    } else {
      return truncateTitle(title, 60, false);
    }
  };

  const errorMsg = () => {
    if (errorMessage) {
      return (
        <Notification
          ariaLabel="Hold creation error"
          id="hold-error-message"
          notificationType="warning"
          notificationContent={errorMessage}
        />
      );
    } else {
      return <></>;
    }
  };

  const teacherSetAvailability = () => {
    if (isLargerThanMobile && teacherSet.availability !== undefined) {
      return (
        <StatusBadge level={availabilityStatusBadge()}>
          {titleCase(teacherSet.availability)}
        </StatusBadge>
      );
    } else {
      return null;
    }
  };

  const mobileteacherSetAvailability = () => {
    if (!isLargerThanMobile && teacherSet.availability !== undefined) {
      return (
        <StatusBadge level={availabilityStatusBadge()}>
          {titleCase(teacherSet.availability)}
        </StatusBadge>
      );
    } else {
      return null;
    }
  };

  const availabilityStatusBadge = () => {
    return teacherSet.availability === "available" ? "medium" : "low";
  };

  const legacyDetailUrl = () => {
    return "http://legacycatalog.nypl.org/record=" + teacherSet.bnumber + "~S1";
  };

  const tsTitle = () => {
    return teacherSet.title ? teacherSet.title : "";
  };

  const orderTeacherSetsInfo = () => {
    if (
      isLargerThanMobile ||
      (!isLargerThanMobile &&
        teacherSet &&
        teacherSet.available_copies > 0 &&
        allowedQuantities.length > 0)
    ) {
      return (
        <Box>
          <VStack align="left">
            <Box
              id="teacher-set-details-order-page"
              bg={tsOrderBoxBgColor}
              color="var(--nypl-colors-ui-black)"
              padding="m"
              borderWidth="1px"
              borderRadius="sm"
              overflow="hidden"
              marginBottom="l"
            >
              <Heading
                id="ts-order-set"
                textAlign="center"
                noSpace
                level="two"
                size="secondary"
                text="Order Set"
              />
              <Heading
                id="ts-available-copies"
                textAlign="center"
                size="callout"
                level="four"
                text={AvailableCopies()}
              />
              {OrderTeacherSets()}
            </Box>
            <HaveQuestions />
          </VStack>
        </Box>
      );
    }
  };

  const teacherSetListDetails = (teacherSet) => {
    return (
      <List
        id="ts-list-details"
        type="dl"
        title="Details"
        marginTop="l"
        key="ts-list-details-key"
      >
        <dt id="ts-suggested-grade-range-text">Suggested Grade Range</dt>
        <dd id="ts-page-suitabilities">{teacherSet.suitabilities_string}</dd>

        <dt id="ts-page-primary-language-text">Primary Language</dt>
        <dd id="ts-page-primary-language">{teacherSet.primary_language}</dd>

        <dt id="ts-page-set-type-text">Type</dt>
        <dd id="ts-page-set-type">{teacherSet.set_type}</dd>

        <dt id="ts-page-physical-desc-text">Physical Description</dt>
        <dd id="ts-page-physical-desc">{teacherSet.physical_description}</dd>

        <dt id="ts-page-notes-content-text">Notes</dt>
        <dd id="ts-page-notes-content">{TeacherSetNotesContent()}</dd>

        <dt id="ts-page-call-number-text">Call Number</dt>
        <dd id="ts-page-call-number">{teacherSet.call_number}</dd>
      </List>
    );
  };

  const mobileTeacherSetOrderButton = () => {
    if (!isLargerThanMobile) {
      if (teacherSet && teacherSet.available_copies <= 0) {
        return (
          <Box
            marginTop="l"
            marginBottom="l"
            id="mobile-teacher-set-details-order-page"
            bg={tsOrderBoxBgColor}
            color={tsOrderTextColor}
            padding="m"
            borderWidth="1px"
            borderRadius="sm"
            overflow="hidden"
          >
            <Heading
              id="mobile-ts-order-set"
              textAlign="center"
              noSpace
              level="two"
              size="secondary"
              text="Set Unavailable"
              color={tsOrderTextColor}
            />
            {teacherSetUnAvailableMsg()}
          </Box>
        );
      } else if (allowedQuantities.length <= 0) {
        return (
          <Box
            marginTop="l"
            marginBottom="l"
            id="mobile-teacher-set-details-order-page"
            bg={tsOrderBoxBgColor}
            color={tsOrderTextColor}
            padding="m"
            borderWidth="1px"
            borderRadius="sm"
            overflow="hidden"
          >
            <Heading
              id="mobile-ts-order-set"
              textAlign="center"
              noSpace
              level="two"
              size="secondary"
              text="Set Unavailable"
            />
            {UnableToOrderAdditionalTeacherSetsMsg()}
          </Box>
        );
      } else {
        return (
          <AnchorLink href="#teacher-set-details-order-page">
            <ButtonGroup marginTop="l" marginBottom="l">
              <Button
                buttonType="noBrand"
                size="small"
                id="mobile-teacher-set-order-button"
              >
                Order This Set
              </Button>
            </ButtonGroup>
          </AnchorLink>
        );
      }
    }
  };

  const displayTeacherSetBooks = () => {
    if (isLargerThanMobile) {
      return (
        <>
          <Heading
            id="ts-page-books-count"
            marginTop="s"
            size="callout"
            level="four"
            text={BooksCount()}
          />
          <SimpleGrid
            id="ts-page-books-panel"
            marginTop="xs"
            columns={5}
            gap="xxs"
          >
            {" "}
            {TeacherSetBooks()}{" "}
          </SimpleGrid>
        </>
      );
    } else if (books.length > 0) {
      return (
        <Accordion
          accordionData={[
            {
              accordionType: "default",
              label: (
                <div id="mobile-ts-page-books-count"> {BooksCount()} </div>
              ),
              panel: TeacherSetBooks(),
            },
          ]}
          id="mobile-ts-page-books-panel"
          panelMaxHeight="500px"
          isDefaultOpen
        />
      );
    }
  };

  return (
    <TemplateAppContainer
      breakout={
        <>
          <Breadcrumbs
            id={"mln-breadcrumbs-ts-details"}
            breadcrumbsData={[
              { url: "//" + process.env.MLN_INFO_SITE_HOSTNAME, text: "Home" },
              {
                url: "//" + window.location.hostname + "/teacher_set_data",
                text: "Teacher Sets",
              },
              {
                url: "//" + window.location.hostname + window.location.pathname,
                text: breadcrumbTitle(tsTitle()),
              },
            ]}
            breadcrumbsType="booksAndMore"
          />
          <Hero
            heroType="tertiary"
            backgroundColor={heroBgColor}
            heading={
              <Heading
                level="one"
                id={
                  "hero-" + window.location.pathname.split(/\/|\?|&|=|\./g)[1]
                }
                text="Teacher Sets"
              />
            }
          />
        </>
      }
      contentTop={errorMsg()}
      contentPrimary={
        <>
          <Flex alignItems="baseline">
            <Heading
              id="ts-title-id"
              noSpace
              level="two"
              size="secondary"
              text={teacherSetTitle()}
            />
            <Spacer />
            {teacherSetAvailability()}
          </Flex>
          <HorizontalRule
            marginTop="s"
            id="ts-detail-page-horizontal-rule-id"
            className={`${colorMode} teacherSetHorizontal`}
          />

          <Flex alignItems="baseline">
            <Spacer />
            {mobileteacherSetAvailability()}
          </Flex>

          {mobileTeacherSetOrderButton()}

          <Heading
            marginTop="l"
            noSpace
            id="ts-header-desc-text"
            level="three"
            size="tertiary"
            text="What is in the box"
          />
          {TeacherSetDescription()}
          {displayTeacherSetBooks()}
          {teacherSetListDetails(teacherSet)}
          <Link
            href={legacyDetailUrl()}
            id="ts-page-details_url"
            type="action"
            target="_blank"
            marginTop="l"
          >
            View in catalog
            <Icon
              name="actionLaunch"
              iconRotation="rotate0"
              size="medium"
              align="left"
            />
          </Link>
        </>
      }
      contentSidebar={orderTeacherSetsInfo()}
      sidebar="right"
    />
  );
}
