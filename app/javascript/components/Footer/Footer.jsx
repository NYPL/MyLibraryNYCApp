import React from "react";
import {
  Link,
  Logo,
  Center,
  useNYPLBreakpoints,
  VStack,
  HStack,
  useColorModeValue,
  Box,
} from "@nypl/design-system-react-components";

function Footer() {
  const { isLargerThanMobile } = useNYPLBreakpoints();
  const footerBgColor = useColorModeValue("ui.bg.default", "dark.ui.bg.default");
  const nyplFullLogo = useColorModeValue("nyplFullBlack", "nyplFullWhite");
  const bplLogo = useColorModeValue("bplBlack", "bplWhite");
  const qplAltLogo = useColorModeValue("qplAltBlack", "qplAltWhite");
  const darkModeIconColor = useColorModeValue(
    "var(--nypl-colors-ui-black)",
    "var(--nypl-colors-dark-ui-typography-heading)"
  );
  const footerLinks = () => {
    return (
      <>
        <Link
          id="nypl-footer-logo-link"
          href="http://nypl.org"
          target="_blank"
          
          //screenreaderOnlyText="New York Public Library"
        >
          <Logo
            decorative
            id="nypl-footer-logo-id"
            name={nyplFullLogo}
            size="small"
          />
        </Link>
        <Link
          id="brooklyn-foooter-logo-link"
          href="http://www.brooklynpubliclibrary.org"
          target="_blank"
          //screenreaderOnlyText="Brooklyn Public Library"
        >
          <Logo
            decorative
            id="brooklyn-foooter-logo-id"
            name={bplLogo}
            size="small"
          />
        </Link>
        <Link
          id="queens-foooter-logo-link"
          href="http://www.queenslibrary.org"
          target="_blank"
          //screenreaderOnlyText="Queens Public Library"
        >
          <Logo
            decorative
            id="queens-foooter-logo-id"
            name={qplAltLogo}
            size="small"
          />
        </Link>
        <Link
          id="nycps-foooter-logo-link"
          href="http://schools.nyc.gov"
          target="_blank"
          //screenreaderOnlyText="New York City Public Schools"
        >
          <Logo
              decorative
              id="nycps-foooter-logo-id"
              size="small"
            >
              <svg width="332" height="63" viewBox="0 0 332 63" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M266.463 28.6509H262.771V25.8255H266.463V28.6509Z" fill={darkModeIconColor}/>
                <path d="M169.13 2.00046H131.547L120.271 13.2751V50.8591L131.547 62.1338H169.13L180.407 50.8591V39.5831L176.649 35.8205H157.855V39.5831H142.822V24.5485H157.855V28.2605H176.649L180.407 24.5485V13.2751L169.13 2.00046Z" fill={darkModeIconColor}/>
                <path d="M56.3773 2.00046H41.344L37.5853 5.75646V20.7898L18.792 2.00046H3.76L0 5.75646V58.3765L3.76 62.1338H18.792L22.552 58.3765V43.3405L41.344 62.1338H56.3773L60.1347 58.3765V5.75646L56.3773 2.00046Z" fill={darkModeIconColor}/>
                <path d="M82.6874 62.1333H97.7207L101.479 58.376V47.1013L120.273 28.308V5.7573L116.514 1.99997H101.479L97.7207 5.7573V13.2746L90.2047 20.7906L82.6874 13.2746V5.7573L78.9287 1.99997H63.8954L60.1367 5.7573V28.308L78.9287 47.1013V58.376L82.6874 62.1333Z" fill={darkModeIconColor}/>
                <path d="M173.67 2.53779V2.00179H176.397V2.53779H175.355V5.20312H174.718V2.53779H173.67Z" fill={darkModeIconColor}/>
                <path d="M177.853 2.00179L178.672 4.29513L179.485 2.00179H180.404V5.20312H179.815V2.62313L178.933 5.20312H178.421L177.529 2.62313V5.20312H176.941V2.00179H177.853Z" fill={darkModeIconColor}/>
                <path d="M196.303 20.5066V15.4794H202.487C203.886 15.4794 204.977 15.1238 205.76 14.4125C206.556 13.7012 206.954 12.6704 206.954 11.3202V11.284C206.954 9.92176 206.556 8.89101 205.76 8.19178C204.977 7.49256 203.886 7.14295 202.487 7.14295H196.303V2.04342H204.079C206.02 2.04342 207.707 2.4292 209.142 3.20076C210.577 3.96027 211.686 5.03322 212.469 6.41961C213.265 7.79395 213.663 9.41543 213.663 11.284V11.3202C213.663 13.1768 213.265 14.7983 212.469 16.1846C211.686 17.559 210.577 18.6259 209.142 19.3854C207.707 20.1329 206.02 20.5066 204.079 20.5066H196.303ZM192.957 28.1378V2.04342H199.594V28.1378H192.957Z" fill={darkModeIconColor}/>
                <path d="M222.867 28.5537C221.433 28.5537 220.209 28.2583 219.196 27.6676C218.184 27.0769 217.412 26.227 216.882 25.1179C216.351 24.0087 216.086 22.6766 216.086 21.1214V8.44495H222.506V19.7471C222.506 20.8683 222.771 21.7483 223.301 22.3873C223.832 23.0141 224.621 23.3276 225.67 23.3276C226.177 23.3276 226.635 23.2372 227.045 23.0563C227.454 22.8755 227.804 22.6223 228.093 22.2968C228.383 21.9713 228.6 21.5795 228.744 21.1214C228.901 20.6633 228.979 20.163 228.979 19.6205V8.44495H235.399V28.1378H228.979V24.6658H228.853C228.515 25.4855 228.069 26.1908 227.515 26.7815C226.96 27.3602 226.297 27.8002 225.526 28.1016C224.754 28.403 223.868 28.5537 222.867 28.5537Z" fill={darkModeIconColor}/>
                <path d="M251.114 28.5537C250.173 28.5537 249.311 28.403 248.528 28.1016C247.744 27.8002 247.063 27.3722 246.484 26.8177C245.918 26.2511 245.472 25.5699 245.146 24.7743H245.019V28.1378H238.6V2.04342H245.019V11.935H245.146C245.484 11.1153 245.936 10.416 246.502 9.83737C247.081 9.24665 247.756 8.80059 248.528 8.4992C249.311 8.18576 250.167 8.02903 251.095 8.02903C252.759 8.02903 254.176 8.4329 255.345 9.24062C256.514 10.0363 257.407 11.1997 258.021 12.7307C258.648 14.2497 258.962 16.0942 258.962 18.2642V18.2823C258.962 20.4523 258.648 22.3029 258.021 23.8339C257.407 25.365 256.508 26.5344 255.327 27.3421C254.158 28.1498 252.753 28.5537 251.114 28.5537ZM248.745 23.3276C249.504 23.3276 250.161 23.1226 250.716 22.7128C251.27 22.3029 251.692 21.7242 251.982 20.9768C252.283 20.2293 252.434 19.3312 252.434 18.2823V18.2642C252.434 17.2275 252.283 16.3353 251.982 15.5879C251.68 14.8284 251.252 14.2497 250.698 13.8519C250.143 13.4541 249.492 13.2551 248.745 13.2551C248.009 13.2551 247.358 13.4601 246.792 13.87C246.237 14.2678 245.803 14.8404 245.49 15.5879C245.176 16.3353 245.019 17.2335 245.019 18.2823V18.3004C245.019 19.3372 245.176 20.2353 245.49 20.9948C245.803 21.7423 246.237 22.321 246.792 22.7308C247.346 23.1287 247.997 23.3276 248.745 23.3276Z" fill={darkModeIconColor}/>
                <path d="M261.566 28.1378V2.04342H267.985V28.1378H261.566Z" fill={darkModeIconColor}/>
                <path d="M271.24 28.1378V8.44495H277.66V28.1378H271.24ZM274.441 6.32919C273.525 6.32919 272.747 6.01575 272.108 5.38886C271.482 4.76196 271.168 4.02054 271.168 3.1646C271.168 2.29659 271.482 1.55517 272.108 0.940337C272.747 0.313446 273.525 0 274.441 0C275.369 0 276.147 0.313446 276.774 0.940337C277.401 1.55517 277.714 2.29659 277.714 3.1646C277.714 4.02054 277.401 4.76196 276.774 5.38886C276.147 6.01575 275.369 6.32919 274.441 6.32919Z" fill={darkModeIconColor}/>
                <path d="M290.228 28.5537C288.166 28.5537 286.382 28.1438 284.875 27.324C283.38 26.4922 282.229 25.3107 281.421 23.7797C280.614 22.2366 280.21 20.3981 280.21 18.2642V18.2462C280.21 16.1364 280.614 14.316 281.421 12.785C282.241 11.2539 283.392 10.0785 284.875 9.2587C286.37 8.43892 288.136 8.02903 290.174 8.02903C292.03 8.02903 293.652 8.37262 295.038 9.05979C296.425 9.7349 297.504 10.6752 298.275 11.8808C299.047 13.0864 299.451 14.4728 299.487 16.04V16.1666H293.591L293.573 15.9857C293.453 15.0816 293.109 14.3401 292.543 13.7615C291.976 13.1828 291.223 12.8935 290.282 12.8935C289.547 12.8935 288.908 13.1044 288.365 13.5264C287.835 13.9483 287.425 14.5632 287.136 15.3709C286.858 16.1666 286.72 17.137 286.72 18.2823V18.3004C286.72 19.4457 286.858 20.4222 287.136 21.2299C287.425 22.0376 287.835 22.6525 288.365 23.0744C288.908 23.4843 289.553 23.6893 290.3 23.6893C291.241 23.6893 291.988 23.412 292.543 22.8574C293.109 22.2908 293.453 21.5373 293.573 20.597L293.61 20.4162H299.505L299.487 20.5247C299.451 22.0557 299.053 23.424 298.293 24.6296C297.546 25.8352 296.485 26.7936 295.11 27.5049C293.748 28.2041 292.121 28.5537 290.228 28.5537Z" fill={darkModeIconColor}/>
                <path d="M203.03 62C200.86 62 198.973 61.6926 197.37 61.0777C195.778 60.4509 194.531 59.5527 193.626 58.3833C192.734 57.2139 192.234 55.7974 192.126 54.1337L192.107 53.8082H198.274L198.31 53.989C198.431 54.5557 198.708 55.0499 199.142 55.4719C199.588 55.8818 200.155 56.2073 200.842 56.4484C201.529 56.6775 202.294 56.792 203.138 56.792C204.018 56.792 204.772 56.6775 205.399 56.4484C206.038 56.2073 206.532 55.8818 206.882 55.4719C207.231 55.062 207.406 54.5858 207.406 54.0433V54.0252C207.406 53.2898 207.087 52.7232 206.448 52.3254C205.809 51.9155 204.724 51.5659 203.193 51.2765L200.516 50.7521C197.936 50.2699 195.971 49.4019 194.621 48.1481C193.283 46.8823 192.614 45.2487 192.614 43.2475V43.2294C192.614 41.5537 193.06 40.101 193.952 38.8713C194.844 37.6296 196.068 36.6712 197.623 35.9961C199.19 35.3089 200.968 34.9653 202.957 34.9653C205.14 34.9653 206.996 35.2908 208.527 35.9418C210.058 36.5808 211.24 37.4849 212.072 38.6543C212.915 39.8237 213.374 41.1981 213.446 42.7773L213.464 43.1571H207.297L207.279 42.9582C207.207 42.3795 206.984 41.8852 206.61 41.4753C206.237 41.0654 205.742 40.746 205.127 40.5169C204.513 40.2879 203.807 40.1733 203.012 40.1733C202.204 40.1733 201.517 40.2879 200.95 40.5169C200.384 40.746 199.95 41.0594 199.648 41.4572C199.359 41.843 199.214 42.2831 199.214 42.7773V42.7954C199.214 43.4946 199.534 44.0492 200.173 44.4591C200.812 44.869 201.83 45.2065 203.229 45.4718L205.905 45.9781C207.762 46.3277 209.287 46.822 210.48 47.4609C211.674 48.0999 212.56 48.9136 213.138 49.9022C213.717 50.8787 214.006 52.0662 214.006 53.4646V53.4827C214.006 55.2187 213.572 56.7257 212.704 58.0036C211.836 59.2815 210.583 60.27 208.943 60.9692C207.304 61.6564 205.332 62 203.03 62Z" fill={darkModeIconColor}/>
                <path d="M226.068 61.9457C224.007 61.9457 222.222 61.5359 220.715 60.7161C219.22 59.8842 218.069 58.7028 217.261 57.1717C216.454 55.6286 216.05 53.7901 216.05 51.6563V51.6382C216.05 49.5285 216.454 47.7081 217.261 46.177C218.081 44.646 219.233 43.4705 220.715 42.6508C222.21 41.831 223.976 41.4211 226.014 41.4211C227.87 41.4211 229.492 41.7647 230.878 42.4518C232.265 43.1269 233.344 44.0673 234.115 45.2728C234.887 46.4784 235.291 47.8648 235.327 49.432V49.5586H229.432L229.413 49.3778C229.293 48.4736 228.949 47.7322 228.383 47.1535C227.816 46.5749 227.063 46.2855 226.122 46.2855C225.387 46.2855 224.748 46.4965 224.205 46.9184C223.675 47.3404 223.265 47.9552 222.976 48.7629C222.699 49.5586 222.56 50.5291 222.56 51.6744V51.6925C222.56 52.8377 222.699 53.8142 222.976 54.622C223.265 55.4297 223.675 56.0445 224.205 56.4665C224.748 56.8764 225.393 57.0813 226.14 57.0813C227.081 57.0813 227.828 56.804 228.383 56.2495C228.949 55.6829 229.293 54.9294 229.413 53.989L229.45 53.8082H235.345L235.327 53.9167C235.291 55.4478 234.893 56.8161 234.133 58.0217C233.386 59.2272 232.325 60.1856 230.951 60.8969C229.588 61.5961 227.961 61.9457 226.068 61.9457Z" fill={darkModeIconColor}/>
                <path d="M237.804 61.5298V35.4355H244.224V45.3813H244.35C244.857 44.0914 245.61 43.1089 246.611 42.4338C247.623 41.7586 248.871 41.4211 250.354 41.4211C251.789 41.4211 253.012 41.7285 254.025 42.3433C255.05 42.9461 255.827 43.8141 256.358 44.9473C256.9 46.0685 257.172 47.4248 257.172 49.0161V61.5298H250.752V50.3905C250.752 49.2211 250.475 48.3048 249.92 47.6418C249.378 46.9787 248.576 46.6472 247.515 46.6472C246.852 46.6472 246.273 46.8099 245.779 47.1354C245.285 47.4489 244.899 47.8829 244.622 48.4374C244.356 48.992 244.224 49.637 244.224 50.3724V61.5298H237.804Z" fill={darkModeIconColor}/>
                <path d="M269.703 61.9457C267.63 61.9457 265.839 61.5419 264.333 60.7342C262.826 59.9264 261.662 58.757 260.842 57.226C260.035 55.6949 259.631 53.8504 259.631 51.6925V51.6563C259.631 49.5345 260.047 47.7081 260.879 46.177C261.71 44.6339 262.88 43.4585 264.387 42.6508C265.894 41.831 267.666 41.4211 269.703 41.4211C271.753 41.4211 273.531 41.831 275.038 42.6508C276.545 43.4585 277.714 44.6279 278.546 46.1589C279.378 47.6779 279.794 49.5104 279.794 51.6563V51.6925C279.794 53.8625 279.384 55.713 278.564 57.2441C277.744 58.7751 276.581 59.9445 275.074 60.7522C273.579 61.5479 271.789 61.9457 269.703 61.9457ZM269.721 57.0813C270.457 57.0813 271.09 56.8764 271.62 56.4665C272.151 56.0445 272.554 55.4297 272.832 54.622C273.121 53.8142 273.266 52.8377 273.266 51.6925V51.6563C273.266 50.5231 273.115 49.5586 272.814 48.7629C272.524 47.9552 272.114 47.3404 271.584 46.9184C271.054 46.4965 270.427 46.2855 269.703 46.2855C268.992 46.2855 268.365 46.4965 267.823 46.9184C267.292 47.3404 266.876 47.9552 266.575 48.7629C266.286 49.5586 266.141 50.5231 266.141 51.6563V51.6925C266.141 52.8377 266.286 53.8142 266.575 54.622C266.864 55.4297 267.274 56.0445 267.805 56.4665C268.347 56.8764 268.986 57.0813 269.721 57.0813Z" fill={darkModeIconColor}/>
                <path d="M291.765 61.9457C289.692 61.9457 287.901 61.5419 286.394 60.7342C284.887 59.9264 283.724 58.757 282.904 57.226C282.096 55.6949 281.693 53.8504 281.693 51.6925V51.6563C281.693 49.5345 282.109 47.7081 282.94 46.177C283.772 44.6339 284.942 43.4585 286.449 42.6508C287.956 41.831 289.728 41.4211 291.765 41.4211C293.815 41.4211 295.593 41.831 297.1 42.6508C298.607 43.4585 299.776 44.6279 300.608 46.1589C301.44 47.6779 301.856 49.5104 301.856 51.6563V51.6925C301.856 53.8625 301.446 55.713 300.626 57.2441C299.806 58.7751 298.643 59.9445 297.136 60.7522C295.641 61.5479 293.851 61.9457 291.765 61.9457ZM291.783 57.0813C292.519 57.0813 293.151 56.8764 293.682 56.4665C294.212 56.0445 294.616 55.4297 294.894 54.622C295.183 53.8142 295.328 52.8377 295.328 51.6925V51.6563C295.328 50.5231 295.177 49.5586 294.875 48.7629C294.586 47.9552 294.176 47.3404 293.646 46.9184C293.115 46.4965 292.488 46.2855 291.765 46.2855C291.054 46.2855 290.427 46.4965 289.884 46.9184C289.354 47.3404 288.938 47.9552 288.637 48.7629C288.347 49.5586 288.203 50.5231 288.203 51.6563V51.6925C288.203 52.8377 288.347 53.8142 288.637 54.622C288.926 55.4297 289.336 56.0445 289.866 56.4665C290.409 56.8764 291.048 57.0813 291.783 57.0813Z" fill={darkModeIconColor}/>
                <path d="M304.46 61.5298V35.4355H310.879V61.5298H304.46Z" fill={darkModeIconColor}/>
                <path d="M322.742 61.9457C320.789 61.9457 319.137 61.6805 317.787 61.1501C316.437 60.6076 315.388 59.8541 314.641 58.8897C313.893 57.9252 313.447 56.804 313.302 55.5261L313.284 55.3634H319.505L319.541 55.5081C319.698 56.1711 320.035 56.6895 320.554 57.0632C321.084 57.4369 321.814 57.6238 322.742 57.6238C323.309 57.6238 323.797 57.5575 324.207 57.4249C324.617 57.2923 324.93 57.1054 325.147 56.8643C325.364 56.6111 325.473 56.3218 325.473 55.9963V55.9782C325.473 55.5442 325.292 55.1946 324.93 54.9294C324.58 54.6521 323.966 54.4231 323.086 54.2422L319.614 53.5731C318.336 53.32 317.257 52.9342 316.377 52.4158C315.509 51.8853 314.852 51.2343 314.405 50.4628C313.971 49.6912 313.754 48.8051 313.754 47.8045V47.7864C313.754 46.4724 314.104 45.3452 314.803 44.4048C315.515 43.4525 316.527 42.7171 317.841 42.1987C319.167 41.6803 320.723 41.4211 322.507 41.4211C324.412 41.4211 326.009 41.7164 327.299 42.3072C328.601 42.8858 329.59 43.6634 330.265 44.6399C330.94 45.6044 331.283 46.6773 331.295 47.8588V48.0034H325.436L325.418 47.8588C325.358 47.2801 325.081 46.7858 324.586 46.3759C324.092 45.954 323.399 45.743 322.507 45.743C321.988 45.743 321.536 45.8154 321.151 45.96C320.765 46.0926 320.463 46.2855 320.246 46.5387C320.041 46.7798 319.939 47.0752 319.939 47.4248V47.4429C319.939 47.7201 320.011 47.9673 320.156 48.1843C320.301 48.4013 320.554 48.5881 320.916 48.7449C321.277 48.9016 321.771 49.0463 322.398 49.1789L325.852 49.866C327.962 50.2759 329.487 50.9149 330.427 51.7829C331.38 52.6388 331.856 53.8022 331.856 55.273V55.2911C331.856 56.6413 331.47 57.8167 330.699 58.8173C329.927 59.8179 328.86 60.5895 327.498 61.132C326.136 61.6745 324.55 61.9457 322.742 61.9457Z" fill={darkModeIconColor}/>
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
    <Box className="app-footer" bg={footerBgColor}>
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
    </Box>
  );
}

export default Footer;
