//
//  StaticContent.swift
//  Afterpay
//
//  Created by Adam Campbell on 18/12/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation

enum StaticContent {

  static let loadingHTML = """
  <html>
    <head>
      <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
      <style>
      .loading::after, .shipping-options__loading-icon::after {
        position: absolute;
        top: 50%;
        left: 50%;
        -webkit-transform: translateX(-50%) translateY(-50%);
        transform: translateX(-50%) translateY(-50%);
        content: "";
        width: 5em;
        height: 5em;
        z-index: 1000000;
        overflow: hidden;
        border-left: 6px solid #CCCCCC;
        border-right: 6px solid #CCCCCC;
        border-bottom: 6px solid #CCCCCC;
        border-top: 6px solid #25659F;
        border-radius: 100%;
        /* overflow: hidden; */
        -webkit-animation-name: rotate;
        animation-name: rotate;
        -webkit-animation-duration: 1s;
        animation-duration: 1s;
        -webkit-animation-timing-function: linear;
        animation-timing-function: linear;
        -webkit-animation-iteration-count: infinite;
        animation-iteration-count: infinite;
      }

      .loading::after {
        border-left-color: #000;
        border-right-color: #000;
        border-bottom-color: #000;
        border-top-color: #b2fce4;
      }

      *, ::before, ::after {
        box-sizing: border-box;
      }

      [class*="column-"] {
        display: inline-block;
        vertical-align: top;
        height: 100%;
        width: 100%;
        padding: 0.5em 0;
      }

      [class*="column-"] {
        display: table-cell;
        vertical-align: middle;
      }

      [class*="column-"].middle {
        vertical-align: middle;
        text-align: center;
      }

      .column-100 {
        width: 100%;
      }

      [class*="column-"] {
        padding: 0;
      }

      body {
        background-color: #ffffff;
        font-family: "Open Sans", "Arial", sans-serif;
        color: #2D3134;
        margin: 0;
        padding: 0;
        height: 100%;
        line-height: 1.3125;
        font-size: 1em;
        -webkit-font-smoothing: antialiased;
      }

      @keyframes rotate {
        from {
          -webkit-transform: translate(-50%, -50%) rotate(0deg);
          transform: translate(-50%, -50%) rotate(0deg);
        }

        to {
          -webkit-transform: translate(-50%, -50%) rotate(359deg);
          transform: translate(-50%, -50%) rotate(359deg);
        }
      }
      </style>
    </head>
    <body>
      <div class="column-100 middle loading"></div>
    </body>
  </html>
  """

}
