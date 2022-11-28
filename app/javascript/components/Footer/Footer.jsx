import React from "react";
import {
  Link,
  Logo,
  Center,
  useNYPLBreakpoints,
  VStack,
  HStack,
} from "@nypl/design-system-react-components";

function Footer() {
  const { isLargerThanMobile } = useNYPLBreakpoints();

  const footerLinks = () => {
    return (
      <>
        <a
          id="nypl-footer-logo-link"
          href="http://nypl.org"
          attributes={{ target: "_blank" }}
        >
          <Logo
            decorative
            id="nypl-footer-logo-id"
            name="nyplFullBlack"
            size="small"
          />
        </a>

        <Link
          id="brooklyn-foooter-logo-link"
          href="http://www.brooklynpubliclibrary.org"
          attributes={{ target: "_blank" }}
        >
          <Logo
            decorative
            id="brooklyn-foooter-logo-id"
            name="bplBlack"
            size="small"
          />
        </Link>

        <Link
          id="queens-foooter-logo-link"
          href="http://www.queenslibrary.org"
          attributes={{ target: "_blank" }}
        >
          <Logo
            decorative
            id="queens-foooter-logo-id"
            name="qplAltBlack"
            size="small"
          />
        </Link>
        <Link
          id="doe-foooter-logo-link"
          href="http://schools.nyc.gov"
          attributes={{ target: "_blank" }}
        >
          <Logo id="doe-foooter-logo" size="medium">
            <svg
              width="340"
              height="61"
              viewBox="0 0 340 61"
              fill="none"
              xmlns="http://www.w3.org/2000/svg"
            >
              <g clipPath="url(#clip0_68248_67680)">
                <path
                  d="M188.912 1.96319H195.58C200.336 1.96319 203.181 4.85386 203.181 9.65253C203.181 14.7339 200.293 17.4712 195.58 17.4712H188.912V1.96319ZM192.952 13.9952H194.863C197.925 13.9325 199.143 12.7379 199.143 9.62986C199.143 6.80719 197.621 5.43919 194.863 5.43919H192.952V13.9952Z"
                  fill="#003366"
                />
                <path
                  d="M207.93 12.738C207.996 14.278 208.886 15.2993 210.449 15.2993C211.34 15.2993 212.209 14.8873 212.557 14.0606H216.01C215.337 16.6673 212.925 17.7966 210.406 17.7966C206.736 17.7966 204.238 15.5806 204.238 11.8033C204.238 8.34997 206.997 5.87397 210.32 5.87397C214.358 5.87397 216.38 8.9153 216.205 12.738H207.93ZM212.513 10.674C212.448 9.41396 211.557 8.37263 210.32 8.37263C209.016 8.37263 208.148 9.30463 207.93 10.674H212.513Z"
                  fill="#003366"
                />
                <path
                  d="M217.615 6.19995H221.134V7.50262H221.177C221.894 6.43862 222.981 5.87462 224.283 5.87462C227.823 5.87462 229.322 8.91462 229.322 12.0853C229.322 15.0173 227.758 17.796 224.565 17.796C223.175 17.796 222.111 17.2773 221.35 16.256H221.307V21.252H217.615V6.19995ZM221.177 11.7173C221.177 13.6933 221.742 14.9733 223.414 14.9733C225.065 14.9733 225.63 13.2573 225.63 11.7173C225.63 10.2826 225.065 8.69729 223.435 8.69729C222.437 8.69729 221.177 9.39329 221.177 11.7173Z"
                  fill="#003366"
                />
                <path
                  d="M230.667 9.67554C230.734 8.19821 231.427 7.24088 232.426 6.65554C233.427 6.09154 234.728 5.87421 236.011 5.87421C238.682 5.87421 241.266 6.45954 241.266 9.65287V14.5835C241.266 15.5382 241.266 16.5822 241.702 17.4715H237.986C237.858 17.1235 237.812 16.7755 237.77 16.4075C236.814 17.4062 235.403 17.7969 234.056 17.7969C231.906 17.7969 230.211 16.7129 230.211 14.3862C230.211 10.7169 234.208 10.9995 236.771 10.4769C237.4 10.3489 237.748 10.1315 237.748 9.43554C237.748 8.58888 236.727 8.26221 235.967 8.26221C234.947 8.26221 234.295 8.71821 234.12 9.67554H230.667ZM235.446 15.5182C237.204 15.5182 237.791 14.5182 237.704 12.1942C237.183 12.5195 236.227 12.5849 235.424 12.8009C234.599 12.9969 233.903 13.3449 233.903 14.2355C233.903 15.1475 234.62 15.5182 235.446 15.5182Z"
                  fill="#003366"
                />
                <path
                  d="M243.377 6.19992H246.96V8.17592H247.002C247.546 6.74126 248.806 5.98259 250.392 5.98259C250.673 5.98259 250.978 6.00392 251.261 6.06926V9.43592C250.782 9.30526 250.349 9.21859 249.848 9.21859C248.025 9.21859 247.069 10.4773 247.069 11.8906V17.4719H243.377V6.19992Z"
                  fill="#003366"
                />
                <path
                  d="M259.404 8.58917H257.123V13.7132C257.123 14.6052 257.645 14.7998 258.448 14.7998C258.751 14.7998 259.077 14.7572 259.404 14.7572V17.4718C258.729 17.4945 258.057 17.5798 257.382 17.5798C254.234 17.5798 253.431 16.6678 253.431 13.6052V8.58917H251.562V6.19983H253.431V2.78917H257.123V6.19983H259.404V8.58917Z"
                  fill="#003366"
                />
                <path
                  d="M260.83 6.19992H264.413V7.74259H264.458C265.13 6.61326 266.323 5.87459 267.691 5.87459C269.105 5.87459 270.363 6.33059 270.971 7.69726C271.863 6.50259 272.971 5.87459 274.491 5.87459C278.074 5.87459 278.465 8.58926 278.465 10.7386V17.4719H274.773V10.8479C274.773 9.63059 274.186 8.91459 273.231 8.91459C271.646 8.91459 271.493 10.1319 271.493 11.9546V17.4719H267.802V11.0639C267.802 9.73859 267.41 8.91459 266.411 8.91459C265.087 8.91459 264.522 9.67592 264.522 11.9773V17.4719H260.83V6.19992Z"
                  fill="#003366"
                />
                <path
                  d="M283.631 12.738C283.695 14.278 284.587 15.2993 286.15 15.2993C287.042 15.2993 287.91 14.8873 288.258 14.0606H291.711C291.038 16.6673 288.627 17.7966 286.107 17.7966C282.437 17.7966 279.939 15.5806 279.939 11.8033C279.939 8.34997 282.697 5.87397 286.019 5.87397C290.059 5.87397 292.081 8.9153 291.906 12.738H283.631ZM288.214 10.674C288.149 9.41396 287.259 8.37263 286.019 8.37263C284.718 8.37263 283.849 9.30463 283.631 10.674H288.214Z"
                  fill="#003366"
                />
                <path
                  d="M293.314 6.19992H296.897V7.74259H296.94C297.614 6.59059 299.134 5.87459 300.481 5.87459C304.237 5.87459 304.542 8.60926 304.542 10.2399V17.4719H300.85V12.0199C300.85 10.4773 301.025 8.91459 299.004 8.91459C297.614 8.91459 297.006 10.0866 297.006 11.3239V17.4719H293.314V6.19992Z"
                  fill="#003366"
                />
                <path
                  d="M313.231 8.58917H310.953V13.7132C310.953 14.6052 311.473 14.7998 312.278 14.7998C312.581 14.7998 312.907 14.7572 313.231 14.7572V17.4718C312.559 17.4945 311.885 17.5798 311.213 17.5798C308.063 17.5798 307.261 16.6678 307.261 13.6052V8.58917H305.393V6.19983H307.261V2.78917H310.953V6.19983H313.231V8.58917Z"
                  fill="#003366"
                />
                <path
                  d="M326.246 5.87457C329.742 5.87457 332.196 8.45856 332.196 11.8452C332.196 15.2359 329.742 17.7959 326.246 17.7959C322.747 17.7959 320.316 15.2359 320.316 11.8452C320.316 8.45856 322.747 5.87457 326.246 5.87457ZM326.246 14.9732C327.962 14.9732 328.504 13.2799 328.504 11.8452C328.504 10.4132 327.962 8.69723 326.246 8.69723C324.53 8.69723 324.008 10.4132 324.008 11.8452C324.008 13.2799 324.53 14.9732 326.246 14.9732Z"
                  fill="#003366"
                />
                <path
                  d="M334.281 8.58926H332.498V6.19992H334.281C334.281 2.96392 335.409 1.96259 338.559 1.96259C339.145 1.96259 339.753 2.00792 340.339 2.02926V4.63459C339.991 4.59192 339.667 4.57192 339.341 4.57192C338.493 4.57192 337.973 4.67992 337.973 5.69992V6.19992H340.187V8.58926H337.973V17.4719H334.281V8.58926Z"
                  fill="#003366"
                />
                <path
                  d="M188.912 25.8257H201.271V29.0617H192.952V31.7791H200.553V34.9044H192.952V37.8591H201.487V41.3337H188.912V25.8257Z"
                  fill="#003366"
                />
                <path
                  d="M214.339 41.3341H210.821V40.0314H210.778C210.061 41.0941 208.974 41.6594 207.671 41.6594C204.131 41.6594 202.633 38.6194 202.633 35.4488C202.633 32.5168 204.197 29.7368 207.39 29.7368C208.779 29.7368 209.843 30.2568 210.603 31.2781H210.647V25.8261H214.339V41.3341ZM206.325 35.5794C206.325 37.1208 206.89 38.8368 208.583 38.8368C210.386 38.8368 210.778 37.1208 210.778 35.6888C210.778 34.0581 210.19 32.5594 208.583 32.5594C206.89 32.5594 206.325 34.1461 206.325 35.5794Z"
                  fill="#003366"
                />
                <path
                  d="M227.626 41.3341H224.042V39.7914H223.999C223.303 40.9434 221.871 41.6594 220.567 41.6594C217.33 41.6594 216.396 39.7914 216.396 36.8381V30.0621H220.088V36.6008C220.088 38.0981 220.74 38.6194 221.914 38.6194C222.716 38.6194 223.934 38.0981 223.934 36.0994V30.0621H227.626V41.3341Z"
                  fill="#003366"
                />
                <path
                  d="M237.03 34.1888C237.009 33.2341 236.161 32.5608 235.228 32.5608C233.165 32.5608 232.838 34.3194 232.838 35.8834C232.838 37.3394 233.469 38.8368 235.033 38.8368C236.313 38.8368 236.966 38.0981 237.14 36.9034H240.722C240.398 39.9221 238.05 41.6594 235.054 41.6594C231.665 41.6594 229.146 39.3354 229.146 35.8834C229.146 32.2981 231.426 29.7368 235.054 29.7368C237.856 29.7368 240.353 31.2141 240.614 34.1888H237.03Z"
                  fill="#003366"
                />
                <path
                  d="M241.964 33.5378C242.03 32.0618 242.724 31.1032 243.722 30.5192C244.724 29.9538 246.025 29.7378 247.308 29.7378C249.978 29.7378 252.562 30.3218 252.562 33.5152V38.4458C252.562 39.4005 252.562 40.4445 252.998 41.3338H249.282C249.154 40.9858 249.109 40.6392 249.066 40.2698C248.11 41.2685 246.7 41.6592 245.353 41.6592C243.202 41.6592 241.508 40.5752 241.508 38.2498C241.508 34.5792 245.505 34.8618 248.068 34.3405C248.697 34.2112 249.045 33.9938 249.045 33.2992C249.045 32.4512 248.025 32.1245 247.264 32.1245C246.244 32.1245 245.592 32.5805 245.417 33.5378H241.964ZM246.742 39.3805C248.501 39.3805 249.088 38.3805 249.001 36.0565C248.48 36.3818 247.524 36.4472 246.721 36.6645C245.896 36.8605 245.2 37.2085 245.2 38.0978C245.2 39.0098 245.917 39.3805 246.742 39.3805Z"
                  fill="#003366"
                />
                <path
                  d="M261.261 32.4517H258.98V37.5757C258.98 38.469 259.503 38.6624 260.305 38.6624C260.611 38.6624 260.935 38.6197 261.261 38.6197V41.3344C260.589 41.357 259.915 41.4424 259.243 41.4424C256.092 41.4424 255.288 40.5304 255.288 37.4677V32.4517H253.42V30.0624H255.288V26.653H258.98V30.0624H261.261V32.4517Z"
                  fill="#003366"
                />
                <path
                  d="M266.463 28.6509H262.771V25.8255H266.463V28.6509Z"
                  fill="#003366"
                />
                <path
                  d="M262.771 30.0629H266.463V41.335H262.771V30.0629Z"
                  fill="#003366"
                />
                <path
                  d="M273.933 29.7375C277.429 29.7375 279.884 32.3202 279.884 35.7082C279.884 39.0988 277.429 41.6602 273.933 41.6602C270.435 41.6602 268.004 39.0988 268.004 35.7082C268.004 32.3202 270.435 29.7375 273.933 29.7375ZM273.933 38.8362C275.649 38.8362 276.192 37.1428 276.192 35.7082C276.192 34.2762 275.649 32.5602 273.933 32.5602C272.217 32.5602 271.696 34.2762 271.696 35.7082C271.696 37.1428 272.217 38.8362 273.933 38.8362Z"
                  fill="#003366"
                />
                <path
                  d="M281.369 30.0625H284.953V31.6051H284.997C285.67 30.4531 287.189 29.7371 288.536 29.7371C292.294 29.7371 292.6 32.4718 292.6 34.1025V41.3345H288.905V35.8825C288.905 34.3398 289.08 32.7771 287.06 32.7771C285.67 32.7771 285.061 33.9491 285.061 35.1865V41.3345H281.369V30.0625Z"
                  fill="#003366"
                />
                <path
                  d="M169.13 0.000457764H131.547L120.271 11.2751V48.8591L131.547 60.1338H169.13L180.407 48.8591V37.5831L176.649 33.8205H157.855V37.5831H142.822V22.5485H157.855V26.2605H176.649L180.407 22.5485V11.2751L169.13 0.000457764Z"
                  fill="#6699CC"
                />
                <path
                  d="M56.3773 0.000457764H41.344L37.5853 3.75646V18.7898L18.792 0.000457764H3.76L0 3.75646V56.3765L3.76 60.1338H18.792L22.552 56.3765V41.3405L41.344 60.1338H56.3773L60.1347 56.3765V3.75646L56.3773 0.000457764Z"
                  fill="#80B24C"
                />
                <path
                  d="M82.6874 60.1333H97.7207L101.479 56.376V45.1013L120.273 26.308V3.7573L116.514 -3.05176e-05H101.479L97.7207 3.7573V11.2746L90.2047 18.7906L82.6874 11.2746V3.7573L78.9287 -3.05176e-05H63.8954L60.1367 3.7573V26.308L78.9287 45.1013V56.376L82.6874 60.1333Z"
                  fill="#FF9933"
                />
                <path
                  d="M173.67 0.537792V0.00179172H176.397V0.537792H175.355V3.20312H174.718V0.537792H173.67Z"
                  fill="#6699CC"
                />
                <path
                  d="M177.853 0.00179172L178.672 2.29513L179.485 0.00179172H180.404V3.20312H179.815V0.623125L178.933 3.20312H178.421L177.529 0.623125V3.20312H176.941V0.00179172H177.853Z"
                  fill="#6699CC"
                />
              </g>
              <defs>
                <clipPath id="clip0_68248_67680">
                  <rect width="340.339" height="60.1337" fill="white" />
                </clipPath>
              </defs>
            </svg>
          </Logo>
        </Link>
      </>
    );
  };

  const footerData = () => {
    if (isLargerThanMobile) {
      return <HStack spacing="xxl">{footerLinks()}</HStack>;
    } else {
      return <VStack spacing="m">{footerLinks()}</VStack>;
    }
  };

  return (
    <div className="app-footer">
      <Center id="mln-footer-data" paddingTop="xxl">
        {footerData()}
      </Center>
      <Center paddingBottom="xxl">
        <Link
          id="mln-terms"
          color="var(--nypl-colors-ui-black)"
          href="http://www.nypl.org/help/about-nypl/legal-notices/website-terms-and-conditions"
          target="_blank"
          margin="s"
        >
          Terms
        </Link>
        |
        <Link
          id="mln-privacy-policy"
          color="var(--nypl-colors-ui-black)"
          href="http://www.nypl.org/help/about-nypl/legal-notices/privacy-policy"
          target="_blank"
          margin="s"
        >
          Privacy Policy
        </Link>
      </Center>
    </div>
  );
}

export default Footer;
