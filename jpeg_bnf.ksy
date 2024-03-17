meta:
  id: jpeg_data
  title: JPEG (Joint Photographic Experts Group) File Interchange Format
  file-extension:
    - jpg
    - jpeg
  endian: be
seq:
  - id: segments
    type: segment
    repeat: eos
types:
  segment:
    seq:
      - id: prefix
        contents: [0xff]
      - id: marker
        type: u1
        enum: marker_enum
      - id: length
        type: u2
        if:
          marker != marker_enum::soi
          and marker != marker_enum::eoi
          and marker != marker_enum::tem
          and (marker >= marker_enum::rst0 and marker <= marker_enum::rst7)
      - id: data
        size: length - 2
        if:
          marker != marker_enum::soi
          and marker != marker_enum::eoi
          and marker != marker_enum::tem
          and (marker >= marker_enum::rst0 and marker <= marker_enum::rst7)
    enums:
      marker_enum:
        - 0x01: tem
        - 0xc4: dht
        - 0xc8: jpg
        - 0xcc: dac
        - 0xd8: soi
        - 0xd9: eoi
        - 0xda: sos
        - 0xdb: dqt
        - 0xdc: dnl
        - 0xdd: dri
        - 0xde: dhp
        - 0xdf: exp
        - 0xfe: com
        - 0xc0: sof0
        - 0xc1: sof1
        - 0xc2: sof2
        - 0xc3: sof3
        - 0xc9: sof9
        - 0xca: sof10
        - 0xcb: sof11
        - 0xc5: sof5
        - 0xc6: sof6
        - 0xc7: sof7
        - 0xcd: sof13
        - 0xce: sof14
        - 0xcf: sof15
        - 0xd0: rst0
        - 0xd1: rst1
        - 0xd2: rst2
        - 0xd3: rst3
        - 0xd4: rst4
        - 0xd5: rst5
        - 0xd6: rst6
        - 0xd7: rst7
        - 0xe0: app0
        - 0xe1: app1
        - 0xe2: app2
        - 0xe3: app3
        - 0xe4: app4
        - 0xe5: app5
        - 0xe6: app6
        - 0xe7: app7
        - 0xe8: app8
        - 0xe9: app9
        - 0xea: app10
        - 0xeb: app11
        - 0xec: app12
        - 0xed: app13
        - 0xee: app14
        - 0xef: app15
        - 0xf0: jpg0
        - 0xf1: jpg1
        - 0xf2: jpg2
        - 0xf3: jpg3
        - 0xf4: jpg4
        - 0xf5: jpg5
        - 0xf6: jpg6
        - 0xf7: jpg7
        - 0xf8: jpg8
        - 0xf9: jpg9
        - 0xfa: jpg10
        - 0xfb: jpg11
        - 0xfc: jpg12
        - 0xfd: jpg13
/*
      - id: content
        type:
          switch-on: marker
          cases:
            '0xFFD8': soi
            '0xFFD9': eoi
            '0xFFDB': dqt
            '0xFFC4': dht
            '0xFFCC': dac
            '0xFFDD': dri
            '0xFFFE': com
            '0xFFE0': appn
            '0xFFDA': sos
            '0xFFC0': sof0
            '0xFFC2': sof2
            # Add all other markers and their associated structures
enums:
  markers:
    - 0x01: tem
    - 0xc4: dht
    - 0xc8: jpg
    - 0xcc: dac
    - 0xd8: soi
    - 0xd9: eoi
    - 0xda: sos
    - 0xdb: dqt
    - 0xdc: dnl
    - 0xdd: dri
    - 0xde: dhp
    - 0xdf: exp
    - 0xfe: com
  nsofb:
    - 0xc0: sof0
    - 0xc1: sof1
    - 0xc2: sof2
    - 0xc3: sof3
    - 0xc9: sof9
    - 0xca: sof10
    - 0xcb: sof11
  dsofb:
    - 0xc5: sof5
    - 0xc6: sof6
    - 0xc7: sof7
    - 0xcd: sof13
    - 0xce: sof14
    - 0xcf: sof15
  rstmb:
    - 0xd0: rst0
    - 0xd1: rst1
    - 0xd2: rst2
    - 0xd3: rst3
    - 0xd4: rst4
    - 0xd5: rst5
    - 0xd6: rst6
    - 0xd7: rst7
  appn:
    - 0xe0: app0
    - 0xe1: app1
    - 0xe2: app2
    - 0xe3: app3
    - 0xe4: app4
    - 0xe5: app5
    - 0xe6: app6
    - 0xe7: app7
    - 0xe8: app8
    - 0xe9: app9
    - 0xea: app10
    - 0xeb: app11
    - 0xec: app12
    - 0xed: app13
    - 0xee: app14
    - 0xef: app15
  jpgnb:
    - 0xf0: jpg0
    - 0xf1: jpg1
    - 0xf2: jpg2
    - 0xf3: jpg3
    - 0xf4: jpg4
    - 0xf5: jpg5
    - 0xf6: jpg6
    - 0xf7: jpg7
    - 0xf8: jpg8
    - 0xf9: jpg9
    - 0xfa: jpg10
    - 0xfb: jpg11
    - 0xfc: jpg12
    - 0xfd: jpg13

    types:
      soi:
        seq: []  # Start of Image has no body
      eoi:
        seq: []  # End of Image has no body
      dqt:
        seq:
          - id: length
            type: u2
          - id: qt_tables
            type: qt_table
            repeat: expr
            repeat-expr: (length - 2) / 65  # Adjust based on actual structure
      qt_table:
        seq:
          - id: qtable_id
            type: u1
          - id: qtable_values
            type: u1
            repeat: expr
            repeat-expr: 64  # 64 values for a quantization table
      dht:
        seq:
          - id: length
            type: u2
          - id: huff_tables
            type: huff_table
            repeat: expr
            repeat-expr: (length - 2) / 17  # Adjust based on actual structure
      huff_table:
        seq:
          - id: htable_id
            type: u1
          - id: htable_values
            type: u1
            repeat: expr
            repeat-expr: 16  # Adjust based on actual structure
      dac:
        seq:
          - id: length
            type: u2
          - id: data
            type: u1
            repeat: expr
            repeat-expr: length - 2
      dri:
        seq:
          - id: length
            type: u2
          - id: restart_interval
            type: u2
      com:
        seq:
          - id: length
            type: u2
          - id: comment
            type: str
            encoding: ASCII
            size: length - 2
      appn:
        seq:
          - id: length
            type: u2
          - id: application_data
            type: str
            size: length - 2
      sos:
        seq:
          - id: length
            type: u2
          - id: components
            type: sos_component
            repeat: expr
            repeat-expr: length - 6
          - id: spectral_selection_start
            type: u1
          - id: spectral_selection_end
            type: u1
          - id: successive_approximation
            type: u1
      sos_component:
        seq:
          - id: component_id
            type: u1
          - id: dc_ac_select
            type: u1
      sof0:  # Start of Frame (Baseline DCT)
        seq:
          - id: length
            type: u2
          - id: precision
            type: u1
          - id: image_height
            type: u2
          - id: image_width
            type: u2
          - id: num_components
            type: u1
          - id: components
            type: frame_component
            repeat: expr
            repeat-expr: num_components
      sof2:  # Start of Frame (Progressive DCT)
        # Similar to sof0 but for progressive JPEGs
      frame_component:
        seq:
          - id: component_id
            type: u1
          - id: sampling_factors
            type: u1
          - id: quantization_table_id
            type: u1
*/
