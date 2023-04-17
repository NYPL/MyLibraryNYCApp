import React from "react";
import { Link, Heading } from "@nypl/design-system-react-components";

export default function HaveQuestions() {
  return (
    <>
      <Heading
        id="heading-tertiary"
        level="two"
        size="tertiary"
        text="Have Questions?"
      />
      <div id="have-questions-links">
        <p className="visitOurText">
          Visit Our{" "}
          <Link id="home-faq-link" type="action" href="/faq">
            FAQ Page
          </Link>
        </p>
        <p>
          Or{" "}
          <Link id="home-contact-link" type="action" href="/contact">
            Contact Us
          </Link>
        </p>
      </div>
    </>
  );
}
