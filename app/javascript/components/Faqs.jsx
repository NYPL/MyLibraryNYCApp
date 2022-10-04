import React, { Component, useState, useEffect } from 'react';
import AppBreadcrumbs from "./AppBreadcrumbs";
import HaveQuestions from "./HaveQuestions";
import SignedInMsg from "./SignedInMsg";
import axios from 'axios';
import { Accordion, Link, List, DSProvider, TemplateAppContainer, SkeletonLoader } from '@nypl/design-system-react-components';
import HTMLReactParser from 'html-react-parser';


export default function Faqs(props) {

  const [faqs, setFaqs] = useState([])

  useEffect(() => {
    axios.get('/faqs/show').then(res => {
        setFaqs(res.data.faqs)
      })
      .catch(function (error) {
       console.log(error)
    })
  }, []);

  const FrequentlyAskedQuestions = () => {
    return faqs.map((data, i) => {
      return {
        label: <div className="hrefLink">{HTMLReactParser(data["question"])}</div>,
        panel: <div className="hrefLink">{HTMLReactParser(data["answer"])}</div>
      }
    })
  }

  const skeletonLoaderForFaqs = () => {
    if (faqs.length <= 0) {
      return <div width="900px"/>
    }
  }

  return (
      <TemplateAppContainer
        breakout={<AppBreadcrumbs />}
        contentTop={<SignedInMsg signInDetails={props} />}
        contentPrimary={
          <>
            {skeletonLoaderForFaqs()}
            <Accordion id="faqs-page" accordionData={FrequentlyAskedQuestions()} />
          </>
        }
        contentSidebar={<HaveQuestions />}
        sidebar="right"
      />
  )
}
