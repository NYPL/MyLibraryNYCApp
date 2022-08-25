import PropTypes from 'prop-types';
import React, { Component, useState, useEffect } from 'react';
import AppBreadcrumbs from "./AppBreadcrumbs";
import HaveQuestions from "./HaveQuestions";
import { Route, BrowserRouter as Router, Switch , Redirect, Link as ReactRouterLink} from "react-router-dom";
import { titleCase } from "title-case";
import AnchorLink from 'react-anchor-link-smooth-scroll'

import axios from 'axios';
import {
  Button,
  SearchBar,
  Select,
  Input,
  SearchButton,
  Card,
  CardHeading,
  CardContent,
  Heading,
  Image, Flex, Spacer, 
  List, Link, DSProvider, TemplateAppContainer, Text, Form, FormRow, FormField, SimpleGrid, ButtonGroup, Box, HorizontalRule, StatusBadge, VStack, Icon, Breadcrumbs, Hero, Notification, useNYPLBreakpoints
} from '@nypl/design-system-react-components';

import TeacherSetOrder from "./TeacherSetOrder";
import mlnImage from '../images/mln.svg'


export default function TeacherSetDetails(props) {

  const [ts_details, setTsDetails] = useState({})
  const [allowed_quantities, setAllowedQuantities] = useState([])
  const [teacher_set, setTeacherSet] = useState("")
  const [active_hold, setActiveHold] = useState("")
  const [books, setBooks] = useState([])
  const [value, setValue] = useState("")
  const [quantity, setQuantity] = useState("1")
  const [access_key, setAccessKey] = useState("")
  const [hold, setHold] = useState({})
  const [teacher_set_notes, setTeacherSetNotes] = useState([])
  const [disableOrderButton, setDisableOrderButton] = useState(true)
  const [errorMessage, setErrorMessage] = useState("")
  const [maxCopiesRequestable, setMaxCopiesRequestable] = useState("")
  const [bookImageHeight, setBookImageHeight] = useState("")
  const [bookImageWidth, setbookImageWidth] = useState("")

  const { isLargerThanSmall, isLargerThanMedium, isLargerThanMobile, isLargerThanLarge, isLargerThanXLarge } = useNYPLBreakpoints();

  const gridColumns = isLargerThanSmall ? 5 : 2;

  useEffect(() => {
    axios.get('/teacher_sets/'+ props.match.params.id)
      .then(res => {
        setAllowedQuantities(res.data.allowed_quantities)
        setTeacherSet(res.data.teacher_set)
        setBooks(res.data.books)
        setActiveHold(res.data.active_hold)
        setTeacherSetNotes(res.data.teacher_set_notes)

        if (res.data.allowed_quantities.length > 0) {
          setDisableOrderButton(false)
        }
      })
      .catch(function (error) {
        console.log(error);
    })
  }, []);


  const handleQuantity = (event) => {
    setQuantity(event.target.value)
  }

  
  const handleSubmit = (event) => {
    event.preventDefault();

    axios.post('/holds', {
        teacher_set_id: props.match.params.id, query_params: {quantity: quantity}
     }).then(res => {
        if (res.request.responseURL == "http://" + process.env.MLN_INFO_SITE_HOSTNAME + ":3000/signin") {
          window.location = res.request.responseURL;
          return false;
        } else {

          if (res.data.status === 'created') {
            props.handleTeacherSetOrderedData(res.data.hold, teacher_set)
            props.history.push("/ordered_holds/"+ res.data.hold["access_key"])
          } else {
            setErrorMessage(res.data.message)
          }
        }
      })
      .catch(function (error) {
       console.log(error)
    })
  }

  const teacherSetTitle = () => {
    return <>{teacher_set["title"]}</>
  }


  const TeacherSetDescription = () => {
    return <div id="ts-page-desc">{teacher_set["description"]}</div>
  }

  const AvailableCopies = () => {
    return <div color="var(--nypl-colors-ui-black)">{teacher_set["available_copies"]} of {teacher_set["total_copies"]} Available</div>
  }

  const BooksCount = () => {
    return <div className="bookTitlesCount">{books.length > 1 ? books.length + " Titles" : books.length >= 1 ? books.length + " Title" : ""}</div>
  }

  const TeacherSetBooks = () => {
    return books.map((data, i) => {
      return <ReactRouterLink id={"ts-books-" + i} to={"/book_details/" + data.id} >
          {BookImage(data)}
        </ReactRouterLink>
    })
  }

  const bookImageDimensions = ({target: img }) => {
    if ((img.offsetHeight === 1) || (img.offsetWidth === 1)) {
      setBookImageHeight(img.offsetHeight)
      setbookImageWidth(img.offsetWidth)
    } else {
      setBookImageHeight(189)
      setbookImageWidth(189)
    }
  }

  const BookImage = (data) => {
    if (data.cover_uri) {
      if (bookImageHeight === 1 && bookImageWidth === 1) {
        return <Image src={mlnImage} aspectRatio="square" size="default" alt="Book image"/>
      } else if (bookImageHeight === 189 && bookImageWidth === 189){
        return <Image id={"ts-books-" + data.id} src={data.cover_uri} aspectRatio="square" size="default" alt="Book image"/>
      } else {
        return <img onLoad={bookImageDimensions} src={data.cover_uri} />
      }
    } else {
      return <Image id={"ts-books-" + data.id} src={mlnImage} aspectRatio="square" size="default" alt="Book image"/>
    }
  }

  const TeacherSetNotesContent = () => {
    return teacher_set_notes.map((note, i) => {
      return <div id={"ts-notes-content-" + i}>{note.content}</div> 
    })
  }

  const teacherSetUnAvailable = () => {
    if (teacher_set <= 0) {
      return <Text sixe="default">This Teacher Set is unavailable. As it is currently being used by other educators, please allow 60 days or more for availability. If you would like to be placed on the wait list for this Teacher Set, contact us at help@mylibrarynyc.org.</Text>
    }
  }

  const OrderTeacherSets = () => {
    if (teacher_set && teacher_set.available_copies <= 0 ) {
      return <Text width="m" size="default"><b>This Teacher Set is unavailable.</b> <i>As it is currently being used by other educators, please allow 60 days or more for availability. If you would like to be placed on the wait list for this Teacher Set, contact us at <a target='_blank' href="mailto:help@mylibrarynyc.org">help@mylibrarynyc.org.</a></i></Text>
    } else if(allowed_quantities.length <= 0) {
      return <Text width="m" size="default"><b>Unable to order additional Teacher Sets.</b> <i>You have <Link href='/account_details' id="ts-page-account-details-link" type="action" target='_blank'>requested</Link> the maximum allowed quantity of this Teacher Set. If you need more copies of this Teacher Set, contact us at <a target='_blank' href="mailto:help@mylibrarynyc.org">help@mylibrarynyc.org.</a></i></Text>
    }
    else {
      return <div>
        <Form gap="grid.xs" id="ts-order-form" >
          <FormField id="ts-order-field">
            <Select id="ts-order-allowed-quantities" showLabel={false} onChange={handleQuantity} value={quantity}>
              { allowed_quantities.map((item, i) => {
                  return (
                    <option id={"ts-quantity-" + i} key={i} value={item}>{item}</option>
                  )
                }, this)
              }
            </Select>
            <Button id="ts-order-submit" buttonType="noBrand" onClick={handleSubmit}> Place Order </Button>
          </FormField>
        </Form>
        <Text isItalic size="default" marginTop="s">Note: Available Teacher Sets will deliver to your school within 2 weeks. For Teacher Sets that are currently in use by other educators, please allow 60 days or more for delivery. If you need materials right away, contact us at <a target='_blank' href="mailto:help@mylibrarynyc.org">help@mylibrarynyc.org.</a></Text>
      </div>
    }
  }

  const truncateTitle = ( str, n, useWordBoundary ) => {
    if (str.length <= n) { return str; }
    const subString = str.substr(0, n-1); // the original check
    return (useWordBoundary 
      ? subString.substr(0, subString.lastIndexOf(" ")) 
      : subString) + "...";
  };

  const breadcrumbTitle = (title) => {
    if (title.length >= 60) {
      return truncateTitle( title, 60, true )
    } else {
      return truncateTitle( title, 60, false )
    }
  }

  const errorMsg = () => {
    if (errorMessage) {
      return <Notification ariaLabel="Hold creation error" id="hold-error-message"
                           notificationType="warning" notificationContent={errorMessage} />
    } else {
      return <></>
    }
  }

  const teacherSetAvailability = () => {
    return teacher_set.availability !== undefined ? teacher_set.availability : ""
  }

  const availabilityStatusBadge = () => {
    return (teacher_set.availability == "available") ? "medium" : "low"
  }

  const legacyDetailUrl = () => {
    return "http://legacycatalog.nypl.org/record="+ teacher_set.bnumber +"~S1"
  }

  const tsTitle = () => {
    return teacher_set.title? teacher_set.title : ""
  }

  
  const mobileOrderButton = () => {
    if (!isLargerThanMobile) {
      return <AnchorLink href="#teacher-set-details-order-page">
         <ButtonGroup marginBottom="l"><Button buttonType="noBrand" size="small" id="mobile-teacher-set-order-button">Order This Set</Button></ButtonGroup>
      </AnchorLink>
    } else {
      null
    }
  }

  return (
    <DSProvider>
      <TemplateAppContainer
        breakout={<>
          <Breadcrumbs id={"mln-breadcrumbs-ts-details"}
                       breadcrumbsData={[{ url: "//"+ process.env.MLN_INFO_SITE_HOSTNAME, text: "Home" }, 
                                         { url: "//"+ window.location.hostname + '/teacher_set_data', text: "Teacher Sets" },
                                         { url: "//"+ window.location.hostname + window.location.pathname, text: breadcrumbTitle(tsTitle()) }]}

                       breadcrumbsType="booksAndMore" />
          <Hero heroType="tertiary"
            backgroundColor="var(--nypl-colors-brand-primary)"
            heading={<Heading level="one" id={"hero-"+ window.location.pathname.split(/\/|\?|&|=|\./g)[1]} text="Teacher Sets"  />} />
        </>}
        contentTop={errorMsg()}
        contentPrimary={
          <>
            <Flex alignItems="baseline">
              <Heading id="heading-secondary" level="one" size="secondary" text={teacherSetTitle() } />
              <Spacer />
              <StatusBadge level={availabilityStatusBadge()}>{titleCase(teacherSetAvailability())}</StatusBadge>
            </Flex>
            <HorizontalRule id="ts-detail-page-horizontal-rulel" className="teacherSetHorizontal" />
            <div>{ mobileOrderButton() }</div>
            <VStack align="left" spacing="s">
              <Heading id="ts-header-desc-text" level="three" size="tertiary" text="What is in the box" />                
               { TeacherSetDescription() }
              <div id="ts-page-books-count"> { BooksCount() } </div>
              <SimpleGrid id="ts-page-books-panel" columns={gridColumns} gap="xxs"> { TeacherSetBooks() } </SimpleGrid>
            </VStack>

            <List id="ts-list-details" type="dl" title="Details" marginTop="s">
              <dt id="ts-suggested-grade-range-text">
                Suggested Grade Range [New]
              </dt>
              <dd id="ts-page-suitabilities">
                {teacher_set.suitabilities_string}
              </dd>

              <dt id="ts-page-primary-language-text">
                Primary Language
              </dt>
              <dd id="ts-page-primary-language">
                {teacher_set.primary_language}
              </dd>

              <dt id="ts-page-set-type-text">
                Type
              </dt>
              <dd id="ts-page-set-type">
                {teacher_set.set_type}
              </dd>

              <dt id="ts-page-physical-desc-text">
                Physical Description
              </dt>
              <dd id="ts-page-physical-desc">
                {teacher_set.physical_description}
              </dd>

              <dt id="ts-page-notes-content-text">
                Notes
              </dt>
              <dd id="ts-page-notes-content">
                {TeacherSetNotesContent()}
              </dd>

              <dt id="ts-page-call-number-text">
                Call Number
              </dt>
              <dd id="ts-page-call-number">
                {teacher_set.call_number}
              </dd>
            </List>
            <Link className="tsDetailUrl" href={legacyDetailUrl()} id="ts-page-details_url" type="action" target='_blank'>
              View in catalog
              <Icon name="actionLaunch" iconRotation="rotate0" size="medium" align="left" />
            </Link>

          </>
        }
        contentSidebar={
          <VStack align="left" spacing="s">
            <Box id="teacher-set-details-order-page" bg="var(--nypl-colors-ui-gray-x-light-cool)" color="var(--nypl-colors-ui-black)" padding="m" borderWidth="1px" borderRadius="sm" overflow="hidden">
              <Heading id="ts-order-set" textAlign="center" noSpace level="three" size="secondary" text="Order Set!" />
              <Heading id="ts-available-copies" textAlign="center" size="callout" level="four" text={AvailableCopies()} />
              {OrderTeacherSets()}
            </Box>
            <div><HaveQuestions /></div>
          </VStack>
        }
        sidebar="right"
      />
    </DSProvider>
  )
}