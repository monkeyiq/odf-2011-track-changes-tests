<?xml version="1.0" encoding="utf-8"?>
<iso:schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:dp="http://www.dpawson.co.uk/ns#" queryBinding="xslt2" schemaVersion="ISO19757-3">
  <iso:title>Test ISO schematron file. Introduction mode</iso:title>
  <iso:ns prefix="dp" uri="http://www.dpawson.co.uk/ns#"/>
  <iso:pattern>
    <iso:rule context="chapter">
      <iso:assert test="title">A chapter should have a title</iso:assert>
    </iso:rule>
  </iso:pattern>
</iso:schema>
