using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ball : MonoBehaviour
{
    public AudioSource audio;

    void OnCollisionEnter(Collision collision)
    {
        audio.Play();
    }
}