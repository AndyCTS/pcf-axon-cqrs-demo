package io.pivotal.catalog.controllers;


import io.pivotal.catalog.PcfAxonCqrsCommandSideApplication;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.http.*;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.junit4.SpringRunner;

import java.nio.charset.Charset;
import java.util.UUID;

import static org.assertj.core.api.BDDAssertions.then;

@RunWith(SpringRunner.class)
@SpringBootTest(classes = PcfAxonCqrsCommandSideApplication.class, webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@ActiveProfiles("mockAmqpAdminForEventPublicationConfig")
public class TestRestWillAddProductToCatalog {

    private String id;
    private String name;
    private String addProductJson;

    private MediaType contentType = new MediaType(MediaType.APPLICATION_JSON.getType(),
            MediaType.APPLICATION_JSON.getSubtype(),
            Charset.forName("utf8"));

    @Autowired
    private TestRestTemplate restTemplate;

    @Before
    public void init() {
        id = UUID.randomUUID().toString();
        name = "test-" + id;
        addProductJson = "{\"id\":\"" + id + "\",\"name\":\"" + name + "\"}";
    }

    @Test
    public void addProductToCatalogueTest() {

        //Arrange
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(contentType);
        HttpEntity<String> entity = new HttpEntity<String>(addProductJson, headers);

        //Act
        ResponseEntity<String> response = restTemplate.exchange("/add", HttpMethod.POST, entity, String.class);

        //Assert
        then(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        then(response.getBody()).isNotEmpty();
        then(response.getBody()).isNotBlank();
    }
}
