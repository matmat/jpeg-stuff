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
      - id: marker
        type: u2
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
