package com.example;

public class DemonstracaoParaTeste {
    private String nome;
    private String sobrenome;
    private Object objetoNulo = null;
    private Object objetoNaoNulo = new Object();
    private static final DemonstracaoParaTeste INSTANCIA_UNICA = new DemonstracaoParaTeste("Unico", "Objeto");

    public DemonstracaoParaTeste(String nome, String sobrenome) {
        this.nome = nome;
        this.sobrenome = sobrenome;
    }

    public String getNomeCompleto() {
        return this.nome + " " + this.sobrenome;
    }

    public boolean ehAdulto(int idade) {
        return idade >= 18;
    }

    public Object getObjetoNulo() {
        return this.objetoNulo;
    }

    public Object getObjetoNaoNulo() {
        return this.objetoNaoNulo;
    }

    public static DemonstracaoParaTeste getInstanciaUnica() {
        return INSTANCIA_UNICA;
    }

    public void setNome(String novoNome) {
        if (novoNome == null || novoNome.trim().isEmpty()) {
            throw new IllegalArgumentException("Nome não pode ser nulo ou vazio");
        }
        this.nome = novoNome;
    }
}
