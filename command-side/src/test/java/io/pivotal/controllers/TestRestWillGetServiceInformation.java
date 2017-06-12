/*
 * Copyright 2012-2014 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package io.pivotal.controllers;

import io.pivotal.PcfAxonCqrsCommandSideApplication;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.context.embedded.LocalServerPort;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.context.junit4.SpringRunner;

import java.util.Map;

import static org.assertj.core.api.BDDAssertions.then;

@RunWith(SpringRunner.class)
@SpringBootTest(classes = PcfAxonCqrsCommandSideApplication.class, webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@TestPropertySource(properties = {"management.port=0", "your.host.is=Test"})
@ActiveProfiles("test")
public class TestRestWillGetServiceInformation {

    @LocalServerPort
    private int port;

    @Value("${local.management.port}")
    private int mgt;

    @Value("${your.host.is}")
    String hostName;

    @Autowired
    private TestRestTemplate testRestTemplate;

    @Test
    public void contextLoads() {
    }

    @Test
    public void testRestEndpoint() {

        //Act
        String body = testRestTemplate.getForObject("/rest", String.class);

        //Assert
        then(body).isEqualTo("{\"yourHostIs\":\"Test\",\"applicationName\":\"pcf-axon-cqrs-demo-command-side\"}");
    }

    @Test
    public void shouldReturn200WhenSendingRequestToController() throws Exception {

        //Act
        @SuppressWarnings("rawtypes")
        ResponseEntity<Map> entity = this.testRestTemplate.getForEntity(
                "http://localhost:" + this.port + "/rest", Map.class);

        //Assert
        then(entity.getStatusCode()).isEqualTo(HttpStatus.OK);
    }

    @Test
    public void responseShouldHaveContent() throws Exception {

        //Act
        @SuppressWarnings("rawtypes")
        ResponseEntity<Map> entity = this.testRestTemplate.getForEntity(
                "http://localhost:" + this.port + "/rest", Map.class);

        //Assert
        then(entity.hasBody()).isTrue();
        then(entity.getBody().containsKey("yourHostIs")).isTrue();
        then(entity.getBody().get("yourHostIs")).isEqualTo("Test");
    }

    @Test
    public void shouldReturn200WhenSendingRequestToActuatorInfoEndpoint() throws Exception {

        //Act
        @SuppressWarnings("rawtypes")
        ResponseEntity<Map> entity = this.testRestTemplate.getForEntity(
                "http://localhost:" + this.mgt + "/info", Map.class);

        //Assert
        then(entity.getStatusCode()).isEqualTo(HttpStatus.OK);
    }

}
