//
//  Assets.swift
//  Afterpay
//
//  Created by Adam Campbell on 27/7/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
import Macaw
import UIKit

enum SVG {

  static var afterpayLogoBlack: UIView {
    // swiftlint:disable:next force_try
    let node = try! SVGParser.parse(text: afterpayBlack)
    let view = SVGView(node: node, frame: .zero)
    view.contentMode = .scaleAspectFit
    view.backgroundColor = .white
    return view
  }

}

// swiftlint:disable line_length
private let afterpayBlack = """
<svg id="Layer_1" data-name="Layer 1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 865.5 180"><title>AP-RGB-black-med</title><path d="M435.74,59.58a43.14,43.14,0,0,1,0,61A42.69,42.69,0,0,1,405.24,133a29.61,29.61,0,0,1-20.4-8.12l-.9-.72v48.33l-21.83,6.89V48.75h21.83v6.5l.9-.91c6.51-6.31,13.9-7.21,20.4-7.21a43.31,43.31,0,0,1,30.5,12.45m-9.2,30.5c0-11.91-9.75-21.84-21.3-21.84s-21.3,9.93-21.3,21.84c0,11.73,9.75,21.84,21.3,21.84s21.3-10.11,21.3-21.84"/><path d="M468.77,120.58a43.14,43.14,0,0,1,0-61,42.69,42.69,0,0,1,30.5-12.45,29.57,29.57,0,0,1,20.4,8.12l.9.72V48.75h21.84v82.66H520.57v-6.5l-.9.9c-6.5,6.32-13.9,7.22-20.4,7.22a43.33,43.33,0,0,1-30.5-12.45M478,90.08c0,11.91,9.74,21.84,21.29,21.84s21.3-9.93,21.3-21.84c0-11.73-9.74-21.84-21.3-21.84S478,78.35,478,90.08"/><path d="M468.77,120.58a43.14,43.14,0,0,1,0-61,42.69,42.69,0,0,1,30.5-12.45,29.57,29.57,0,0,1,20.4,8.12l.9.72V48.75h21.84v82.66H520.57v-6.5l-.9.9c-6.5,6.32-13.9,7.22-20.4,7.22a43.33,43.33,0,0,1-30.5-12.45M478,90.08c0,11.91,9.74,21.84,21.29,21.84s21.3-9.93,21.3-21.84c0-11.73-9.74-21.84-21.3-21.84S478,78.35,478,90.08"/><polygon points="564.25 179.41 583.92 131.59 550.89 48.75 575.08 48.75 595.65 100.18 616.59 48.75 640.59 48.75 587.89 179.41 564.25 179.41"/><polygon points="564.25 179.41 583.92 131.59 550.89 48.75 575.08 48.75 595.65 100.18 616.59 48.75 640.59 48.75 587.89 179.41 564.25 179.41"/><path d="M42.75,132.15A42.57,42.57,0,0,1,12.81,120a42.52,42.52,0,0,1,0-59.86A42.51,42.51,0,0,1,42.75,48c11.43,0,21,6.05,27.11,11.12l1.75,1.46V49.81H85v80.54H71.61V119.56L69.86,121c-6.06,5.07-15.68,11.12-27.11,11.12m0-71.11a29,29,0,1,0,28.86,29A29,29,0,0,0,42.75,61"/><path d="M109.25,130.34V62.49H97V49.81h12.27V26c0-14.58,11.58-26,26.36-26h16.85l-3.4,12.67H136c-7.11,0-13.34,6.4-13.34,13.7V49.81h25.45V62.49H122.64v67.85Z"/><path d="M198.6,130.34A26.39,26.39,0,0,1,172.23,104V62.49H160V49.81h12.27V0h13.39V49.81h25.45V62.49H185.62v41.12c0,7.36,6.36,14.06,13.34,14.06H212l3.4,12.67Z"/><path d="M256.25,131.79a36,36,0,0,1-27.15-12.28,41.36,41.36,0,0,1-10.93-25.36,25.61,25.61,0,0,1-.18-3.71,44.09,44.09,0,0,1,1.06-9.52,42.49,42.49,0,0,1,10-19.55,36.78,36.78,0,0,1,54.56,0,40.74,40.74,0,0,1,10,19.5,54.55,54.55,0,0,1,1,11.91H230.85v1.43c1.87,14.26,12.63,25.06,25.05,25.25a32.67,32.67,0,0,0,20.38-8.4l11.17,6.67a47.1,47.1,0,0,1-9.89,8.06,45.75,45.75,0,0,1-21.31,6m0-70.21c-10.35,0-20,7.47-23.92,18.58l-.13.24-.77,1.54H281.1l-1-1.9c-3.71-11-13.32-18.46-23.87-18.46"/><path d="M307.79,130.34V49.81h13.39V60L323,57.94c4.74-5.24,18.7-9.51,28-9.9l-3.27,13.37c-14.73.43-26.58,11.91-26.58,26v43Z"/><path d="M756.23,71.58,779.68,58c-2.59-4.55-2-3.45-4.32-7.74-2.5-4.55-1.56-6.34,3.61-6.38q22.57-.15,45.14,0c4.48,0,5.55,1.94,3.31,5.88q-11.16,19.64-22.56,39.14c-2.42,4.15-4.54,4.14-7.08.08s-1.91-3.14-4.7-7.87L769.71,94.64a18.07,18.07,0,0,0,1.53,2.82c5.79,10.08,8.38,14.89,14.36,24.85,7.09,11.81,21.95,12.52,30.39,1.61a35.06,35.06,0,0,0,2.57-3.83q21.3-36.9,42.52-73.84a29.32,29.32,0,0,0,3.34-8A17.69,17.69,0,0,0,847.1,16.6q-45.65-.24-91.3.09a17.88,17.88,0,0,0-16.1,26.19c2,4,4.37,7.75,6.6,11.59,4.19,7.24,5.3,9.15,9.93,17.11"/><path d="M688.57,147.57c0-9.13,0-27,0-27s-3.74,0-8.8,0-6.21-1.82-3.67-6.27q11.1-19.44,22.46-38.75c2.24-3.82,4.23-4.16,6.69.09,7.47,12.94,15,25.86,22.33,38.85,2.36,4.15,1.29,6-3.46,6.12h-9.09v27.07h31.66c13.66-.2,21.67-12.6,16.52-25.28a34.71,34.71,0,0,0-2-4.11Q740.2,81.61,719.08,45a29.15,29.15,0,0,0-5.2-6.85,17.55,17.55,0,0,0-27.2,4.08q-22.95,39-45.42,78.37a17.74,17.74,0,0,0,14.46,26.86c4.39.28,23.16.12,32.85.12"/></svg>
"""
// swiftlint:enable line_length
