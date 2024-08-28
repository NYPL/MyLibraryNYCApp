import React from "react";
import { useColorModeValue, Link } from "@nypl/design-system-react-components";
import { useNavigate } from "react-router-dom";
const BookTitles = ({ books, teacherSet }) => {
  const navigate = useNavigate();

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

  const windowScrollTop = (e, data) => {
    e.preventDefault();
    navigate("/book_details/" + data.id, {
      state: { tsTitle: data.title, tsId: teacherSet["id"] },
    });
  };

  return <>{bookTitles(books)}</>;
};

export default BookTitles;
