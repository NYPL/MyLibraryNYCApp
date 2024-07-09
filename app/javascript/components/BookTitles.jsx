import React from "react";
import {
  useColorModeValue,
  Link,
} from "@nypl/design-system-react-components";

const BookTitles = ({ books }) => {
  const titleColor = useColorModeValue(
    "var(--nypl-colors-ui-link-primary)",
    "var(--nypl-colors-dark-ui-link-primary)"
  );

  const bookTitles = (books) => {
    if (books && books.length > 0) {
      return (
        <>
          <dt id="ts-page-book-titles-text">Book titles</dt>
          <dd id="ts-page-book-titles">
            {books.map((book, i) =>
              book.title !== null ? (
                <li key={"ts-books-key-" + i}>
                  <Link
                    id={"ts-books-" + i}
                    href="#"
                    onClick={(e) => {
                      windowScrollTop(e, book);
                    }}
                    color={titleColor}
                  >
                    {book.title}
                  </Link>
                </li>
              ) : null
            )}
          </dd>
        </>
      );
    } else {
      return null;
    }
  };

  return <>{bookTitles(books)}</>;
};

export default BookTitles;
