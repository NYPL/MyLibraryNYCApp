import React from "react";

const BookTitles = ({ books }) => {
  const bookTitles = (books) => {
    console.log(books); // Log books to debug

    if (books && books.length > 0) {
      return (
        <>
          <dt id="ts-page-book-titles-text">Book titles</dt>
          <dd id="ts-page-book-titles">
            {books.map((book, i) =>
              book.title !== null ? (
                <li key={"ts-books-key-" + i}>
                  <a
                    id={"ts-books-" + i}
                    href="#"
                    onClick={(e) => {
                      windowScrollTop(e, book);
                    }}
                  >
                    {book.title}
                  </a>
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
