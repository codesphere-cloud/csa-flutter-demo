# This rewrite ensures compatibility with Nix 2.16 by avoiding the newer
# syntax for default function arguments when importing nixpkgs with attributes.
{ pkgs ? null }:

let
  # Use a robust if/then/else block to handle the default 'pkgs' argument.
  # This explicitly checks if pkgs is null (i.e., not passed) and imports <nixpkgs>
  # if a package set wasn't provided.
  resolvedPkgs = if pkgs == null
    then import <nixpkgs> {}
    else pkgs;
in

with resolvedPkgs; [
  flutter                    # Flutter SDK for building the frontend
  pkg-config                 # For package configuration
]
