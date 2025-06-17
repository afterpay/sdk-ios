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
      .loader {
        position: absolute;
        top: 50%;
        left: 50%;
        -webkit-transform: translateX(-50%) translateY(-50%);
        transform: translateX(-50%) translateY(-50%);
        text-align: center;
      }
      .loader > svg {
        animation: rotate 1s linear infinite;
      }
      @keyframes rotate {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
      }
      </style>
    </head>
    <body>
      <div class="loader">
        <svg width="56" height="56" viewBox="0 0 56 56" fill="none" xmlns="http://www.w3.org/2000/svg">
          <mask id="ref-02908263845776211">
            <g clip-path="url(#ref-022440184599265145)">
              <g clip-path="url(#ref-07814891566233401)">
                <image width="56" height="56" xlink:href="data:image/png;base64,
                  iVBORw0KGgoAAAANSUhEUgAAADgAAAA4CAYAAACohjseAAAHzklEQVR4nL2Z22sU
                  SxDGuzdXBcU3/wH/Ot8En333TbwTRUXRI4qKIqKIKOIlmKiYqImJq5DjNfGaZHNP
                  5szX2Rpreqq6e+NyBtvumZ2Z9G+/r6p6Zq1pbu/evcustUZsNWtqtlY5XqvVKmOt
                  R+vo6DCxbXV11SwuLpqFhQWztLRU9DiGhjHt03h5eXl9vJyPl5bNzp07Ld3PDer1
                  uoPDXgUiEcyH4sfpWAogJkuAvA8BclCC3b17t2Oz4+PjunJCE+FIYaa0pGBnZ2cU
                  kIPxsa+mBElwBLpnzx5rx8bGkgFbUc4/hi0GuLa25iDmF+bX4RYWVTVDKnJI++bN
                  m78C1IA2AogJzc/PF+oBlCAxXlpcqti1AtmMQ4xXVlaMHR0dTQIsxZRnxRgkxV4M
                  0EHlgBzSbxxQUtBX0Y6MjLQMqAGpCnbkYxOOQdhzbm7OQVDvg0pJJwTpAF+/ft02
                  QGmft1AWhZ0ajYaDAiBXknoNMJRs7KtXrxIB0cfjzm9k0RggB0NPY9+2KaWjBPjy
                  5cuWk0zMmkXLrYlYjQFmWWYacw3TmG0UcBxWs2uKTe3w8HAJEJuYWJSSQMpqluT7
                  WgxiIrAn2mxj1sw1yoBS4pHqo2RTOzQ0lPlgqfGnqcfB+FgDxORnZ2ddAxDBciU1
                  SKlcYFwkmRcvXmQhOK000L5mzY5aR9ETpAY4PT3t4JyCTVAOKCUdqfBLcWifP39e
                  icECWFhkpyQWHnN8LAEie/7+/dvMzMy4pkFWVFz8s9KRIAvAZ8+eRS0q2VQC5TAc
                  kJoEiMkDjENyQA7Ja6SfUbWlm3369GnFoqFEk1LrHGDTnoCiz7q7u0V7/vz50/Vo
                  AERPShKkllG1pRv1dmBgIJPAUlUMWZMrh76rq6tizx8/fhSApCKBcpsSpJ9stKJf
                  JJknT56UFEzKpkqC+ZNMANZZgkPvA2LiAPz+/bv59euXA0TzAbmK/urGLxkEhi/P
                  Lbb7+/vFGJRAUxT0G6AAJwES3Ldv35yKaByQko6UbHxIDoZ1LW328ePHhYIxyCpg
                  s8hTWWDZknoCQ89jEK8mvnz5YiYnJx0gWZWU5AlHKxk8qQBM2uzDhw9LCqbYNVTg
                  edy51pWDdXW7cU9PTym5ECAalEQjFQlQUpFsCcW4WiLggwcPsmLHAbhRcjyGAKEc
                  NajHAQH14cMH8/nzZwcKFQmQq0glA42DpW72/v37FYtKavL9UCz61nStu8v09vSa
                  3t5edw/YqV6vO0CCnJqaKqwKQF42KNZiaomA9+7dKyyaCqopyZdkHBDKbdq0yTVs
                  UAqA4+PjDvDTp0/m69evpViEgrAl4utvNnv37t2sdKAAcv//Oeb+hWsktykBwppQ
                  Dm3Lli3ufm/rb83w0LAZGxsz79+/dwqSigCEHTeilgh4586dUgxKsGXwcIb1VST1
                  Nm/ebLZt2+auy/+mGRwcNKOjo07JiX8nzNTklEsg7d7s7du3VcDKsaaKErAUk1Qa
                  SL3t27c7W16+fNk8evTI5I9qZmJiom1qiYC3bt0qJZngyTGFmY19yK1bt5odO3aY
                  vXv3mr6+PvxU0GYUZc43b97M4qe1ZxsZGTG7du36v/6c2+yNGzcqgHhHom3+Z7TP
                  ezTYDg0lAbULqR8xlz9/urqHRILjtLRCk+7VytxEwOvXr5euyKeH/9SbakA+GJZi
                  mDzSPJIHUj/APn786Io8ahwtt2gNiWs4LG/aPGLg9tq1a5l2IoctATWPS2Acjn4p
                  oodalADUOqiJfVp20VqSIDloCDYETMfs1atXM+3EmFoaHFfP/a7QfKlEqxOM+QqF
                  P+bQ9RKkBKvZmnp75cqVLHTCRuDQaMIESA+t/K2Z9ERAje7H798qqFPw0qVLUcAU
                  OF89riB/d+LDaYCSir5lNVA+d3vx4sWMx5vkcR8qph7FX/HTcvPlLP08BhX5U7j0
                  JM4B/eSjxabU7IULF7ISiJBAJOVSAElF/iqPv2bw30RLCvqQPmAM1J4/fz4LKZYC
                  JwFyFfmPIT4cP4eSTAhQggtB2nP/nMska8bgqOcT8AF5LPKkQ8Xfh+Pq8bqoxWIS
                  4NmzZ7MUuJB6MUAOgM/5SyIfzlcvlGwkQB/WnjlzJkuBi9nTz6I+qG9DHneuX82v
                  WanasxVASUl7+vTpTM2YWX7BWuuAHM6PSTpGZYHHnW9PyaIpyYaP7alTp6IKSt9U
                  DFACxTlaxozZM1QTQ5D25MmTWQguJf5CkBwAn3MlY3Hn2zNUDzWb2hMnTgQBiwub
                  dnU3ZWNpAhokAYbg+DItJYtGAY8fP16JQf+kmEX9TKrZ1QeUal7R1vLzV+NwUcBj
                  x44lKShZQrOoBMuVicFJ96Ox9LeDgH19fSJgagaNxaIGGwIT4ZqKthKDGNujR4+W
                  sqj/DbRiUekblybux5l2Xiz+UkqFPXLkSFssmgpJ1xcPt16shRKLZFFNgMKihw8f
                  TsuiLai43gBWBYZ6uF5Uz7PhRrJnxaKHDh1SASXJg4B53PIJclD69n2bSkrHAGPx
                  V1Lw4MGDbQH0j0mTwzn+2zPNkqX95hen2VOaZ6HggQMH/gowza56OQnFG90/FHua
                  NQsF9+/f33KZ0JTM8E2v8WOrbp9PMASWYslW4m9gYGD9x4V9+/YJkOuTTc2m0jfM
                  444D8lhMWamE/pYG2N/f79j+AwWkrOWD7HTiAAAAAElFTkSuQmCC">
                </image>
              </g>
            </g>
          </mask>
          <clipPath id="ref-022440184599265145">
            <path transform="matrix(1 0 0 -1 0 56)" d="M0 0h56v56H0Z"></path>
          </clipPath>
          <clipPath id="ref-07814891566233401">
            <path transform="matrix(1 0 0 -1 3.5 59.5)"
              d="M52.5 31.5a3.5 3.5 0 0 1-7 0h7Zm-28 21a3.5 3.5 0 1 1 0
              7v-7Zm21-21c0-11.598-9.402-21-21-21v-7c15.464 0 28 12.536 28 28h-7Zm-21-21c-11.598
              0-21 9.402-21 21h-7c0-15.464 12.536-28 28-28v7Zm-21 21c0 11.598
              9.402 21 21 21v7c-15.464 0-28-12.536-28-28h7Z">
            </path>
          </clipPath>
          <g mask="url(#ref-02908263845776211)">
            <clipPath id="ref-0043789384087099426">
              <path transform="matrix(1 0 0 -1 3.5 59.5)"
                d="M52.5 31.5a3.5 3.5 0 0 1-7 0h7Zm-28 21a3.5 3.5
                0 1 1 0 7v-7Zm21-21c0-11.598-9.402-21-21-21v-7c15.464
                0 28 12.536 28 28h-7Zm-21-21c-11.598 0-21 9.402-21
                21h-7c0-15.464 12.536-28 28-28v7Zm-21 21c0 11.598
                9.402 21 21 21v7c-15.464 0-28-12.536-28-28h7Z">
              </path>
            </clipPath>
            <g clip-path="url(#ref-0043789384087099426)">
              <path fill="#00D64F" d="M0 0h56v56H0z"></path>
            </g>
          </g>
        </svg>
      </div>
    </body>
  </html>
  """

}
