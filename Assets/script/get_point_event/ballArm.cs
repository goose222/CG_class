using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ballArm : MonoBehaviour
{
    AudioSource audio;
    void start()
    {
        audio = GetComponent<AudioSource>();
    }

    void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.name == "ball")
        {
            audio.Play();
        }
    }
}