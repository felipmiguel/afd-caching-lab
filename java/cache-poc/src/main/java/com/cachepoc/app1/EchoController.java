package com.cachepoc.app1;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;


@RestController
public class EchoController {


    @GetMapping("/{message}")
    public String echo(@PathVariable String message) {
        return "Echo from app1: " + message;
    }
}
