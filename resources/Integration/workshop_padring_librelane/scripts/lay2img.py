# SPDX-FileCopyrightText: © 2025 Leo Moser <leo.moser@pm.me>
# SPDX-License-Identifier: Apache-2.0

import os
import argparse
import klayout.lay as lay
import klayout.db as db


def main(input_layout, output_image, width, height, oversampling, pdk_root, pdk):

    # Background colors
    background_white = "#FFFFFF"
    background_black = "#000000"

    lv = lay.LayoutView()

    lv.set_config("grid-visible", "false")
    lv.set_config("grid-show-ruler", "false")
    lv.set_config("text-visible", "false")

    lv.load_layout(input_layout, 0)
    lv.max_hier()

    top_cell = lv.active_cellview().layout().top_cell()
    top_bbox = top_cell.dbbox()
    aspect_ratio = top_bbox.width() / top_bbox.height()

    if not height and not width:
        width = 1024

    if not height:
        height = int(width / aspect_ratio)

    # Load the layer properties
    lv.load_layer_props(
        os.path.join(pdk_root, pdk, "libs.tech", "klayout", "tech", "gf180mcu.lyp")
    )

    # Disable some layers
    enabled_layers = [
        (22, 0),
        (21, 0),
        (204, 0),
        (55, 0),
        (30, 0),
        (32, 0),
        (31, 0),
        (49, 0),
        (33, 0),
        (34, 0),
        (35, 0),
        (36, 0),
        (38, 0),
        (42, 0),
        (40, 0),
        (46, 0),
        (41, 0),
        (81, 0),
        (37, 0),
    ]
    for lyp in lv.each_layer():
        layer_datatype = (lyp.source_layer, lyp.source_datatype)

        if layer_datatype not in enabled_layers:
            lyp.visible = False

    # Save the images
    base_name = os.path.splitext(os.path.basename(output_image))[0]
    directory = os.path.dirname(output_image)

    lv.set_config("background-color", background_white)
    lv.save_image_with_options(
        os.path.join(directory, base_name + "_white.png"),
        width,
        height,
        oversampling=oversampling,
    )

    lv.set_config("background-color", background_black)
    lv.save_image_with_options(
        os.path.join(directory, base_name + "_black.png"),
        width,
        height,
        oversampling=oversampling,
    )


if __name__ == "__main__":

    pdk_root = os.getenv("PDK_ROOT", "gf180mcu")
    pdk = os.getenv("PDK", "gf180mcuD")

    parser = argparse.ArgumentParser(
        prog="lay2img", description="Convert a layout to an image."
    )
    parser.add_argument("layout", help="input layout")
    parser.add_argument("image", help="output image")
    parser.add_argument("--width", type=int, default=None, help="image width")
    parser.add_argument("--height", type=int, default=None, help="image height")
    parser.add_argument(
        "--oversampling", type=int, default=1, help="oversampling factor"
    )

    args = parser.parse_args()

    main(
        args.layout,
        args.image,
        args.width,
        args.height,
        args.oversampling,
        pdk_root,
        pdk,
    )
