import React, { useState, useEffect } from "react";
import AppBreadcrumbs from "./../AppBreadcrumbs";
import HaveQuestions from "./../HaveQuestions/HaveQuestions";
import SignedInMsg from "./../SignedInMsg";
import axios from "axios";
import {
  Accordion,
  TemplateAppContainer,
  useColorMode,
} from "@nypl/design-system-react-components";
import HTMLReactParser from "html-react-parser";

export default function Faqs(props) {
  
  const [faqs, setFaqs] = useState([]);
  const { colorMode } = useColorMode();

  useEffect(() => {
    document.title = "Frequently Asked Questions | MyLibraryNYC";
    if (env.RAILS_ENV !== "test") {
      window.scrollTo(0, 0);
    }

    axios
      .get("/faqs/show")
      .then((res) => {
        setFaqs(res.data.faqs);
      })
      .catch(function (error) {
        console.log(error);
      });
  }, []);

  const FrequentlyAskedQuestions = () => {
    return faqs.map((data) => {
      return {
        label: (
          <div className={`${colorMode} hrefLink`}>{HTMLReactParser(data["question"])}</div>
        ),
        panel: (
          <div className={`${colorMode} hrefLink`}>{HTMLReactParser(data["answer"])}</div>
        ),
      };
    });
  };

  const skeletonLoaderForFaqs = () => {
    if (faqs.length <= 0) {
      return <div width="900px" />;
    }
  };

  return (
    <TemplateAppContainer
      breakout={<AppBreadcrumbs />}
      contentTop={<SignedInMsg signInDetails={props} />}
      contentPrimary={
        <>
          {skeletonLoaderForFaqs()}
          <Accordion
            id="faqs-page"
            accordionData={FrequentlyAskedQuestions()}
          />
        </>
      }
      contentSidebar={<HaveQuestions />}
      sidebar="right"
    />
  );
}
