package com.example;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.Test;

class TesteDosAsserts {

    @Test
    void testaAssertEquals() {
        DemonstracaoParaTeste demo = new DemonstracaoParaTeste("JUnit", "Teste");
        assertEquals("JUnit Teste", demo.getNomeCompleto(), "O nome completo deveria ser 'JUnit Teste'");
    }

    @Test
    void testaAssertTrue() {
        DemonstracaoParaTeste demo = new DemonstracaoParaTeste("Qualquer", "Nome");
        assertTrue(demo.ehAdulto(10), "Idade 20 deveria retornar true para ehAdulto");
    }

    @Test
    void testaAssertFalse() {
        DemonstracaoParaTeste demo = new DemonstracaoParaTeste("Qualquer", "Nome");
        assertFalse(demo.ehAdulto(15), "Idade 15 deveria retornar false para ehAdulto");
    }

    @Test
    void testaAssertNull() {
        DemonstracaoParaTeste demo = new DemonstracaoParaTeste("Qualquer", "Nome");
        assertNull(demo.getObjetoNulo(), "Este método deveria retornar um objeto nulo");
    }

    @Test
    void testaAssertNotNull() {
        DemonstracaoParaTeste demo = new DemonstracaoParaTeste("Qualquer", "Nome");
        assertNotNull(demo.getObjetoNaoNulo(), "Este método não deveria retornar um objeto nulo");
    }

    @Test
    void testaAssertSame() {
        DemonstracaoParaTeste instancia1 = DemonstracaoParaTeste.getInstanciaUnica();
        DemonstracaoParaTeste instancia2 = DemonstracaoParaTeste.getInstanciaUnica();
        assertSame(instancia1, instancia2, "As duas variáveis deveriam apontar para o mesmo objeto");
    }

    @Test
    void testaAssertNotSame() {
        DemonstracaoParaTeste instanciaUnica = DemonstracaoParaTeste.getInstanciaUnica();
        DemonstracaoParaTeste novaInstancia = new DemonstracaoParaTeste("Outro", "Objeto");
        assertNotSame(instanciaUnica, novaInstancia, "As duas variáveis deveriam apontar para objetos diferentes");
    }

    @Test
    void testaFail() {
        DemonstracaoParaTeste demo = new DemonstracaoParaTeste("Teste", "Fail");
        try {
            demo.setNome(null);
            fail("Deveria ter lançado uma IllegalArgumentException, mas não o fez.");
        } catch (IllegalArgumentException e) {
            assertEquals("Nome não pode ser nulo ou vazio", e.getMessage());
        }
    }
}